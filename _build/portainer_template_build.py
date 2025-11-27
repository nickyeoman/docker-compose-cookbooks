#!/usr/bin/env python3
"""
Portainer templates generator (Portainer CE compatible, v3 format)
Usage:
  python3 _build/portainer_template_build.py [--nologo] [--branch BRANCH] [--output PATH] [--no-skip-volpath]
Defaults:
  branch = master
  output = ./templates.json
  skips projects containing "${VOL_PATH" by default (use --no-skip-volpath to disable)
  Note: Generates v3 format with unique IDs to fix compatibility issues in Portainer 2.22+.
"""
from pathlib import Path
import argparse
import json
import re
import requests
import sys
from typing import List, Dict
# -------------------------
# Config / Defaults
# -------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
DEFAULT_OUTPUT = REPO_ROOT / "templates.json"
ASSETS_BASE = "https://i.4lt.ca/cookbooks"
GITHUB_RAW_BASE_TEMPLATE = "https://raw.githubusercontent.com/{owner}/{repo}/{branch}"
GITHUB_OWNER = "nickyeoman"
GITHUB_REPO = "docker-compose-cookbooks"
DEFAULT_BRANCH = "master"
SKIP_VOLPATH_PATTERN = "${VOL_PATH"
# Regex
VAR_RE = re.compile(r"\$\{([^:}]+)(?:[:-]([^}]+))?\}")
# -------------------------
# Helpers
# -------------------------
def read_text_safe(p: Path) -> str:
    try:
        return p.read_text()
    except Exception:
        return ""
def write_atomic(path: Path, data: str):
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(data)
    tmp.replace(path)
def slugify_for_name(s: str) -> str:
    # produce a safe component for volume names etc.
    s = s.strip().lower()
    s = re.sub(r"[^a-z0-9_\-]+", "-", s)
    s = re.sub(r"-{2,}", "-", s)
    s = s.strip("-")
    if not s:
        return "x"
    return s
# -------------------------
# README Overview extraction
# -------------------------
def extract_overview(readme_path: Path, project_name: str) -> str:
    text = read_text_safe(readme_path)
    if not text:
        return f"{project_name} description to come"
    lines = text.splitlines()
    overview = []
    in_section = False
    for line in lines:
        stripped = line.strip()
        if stripped == "## Overview":
            in_section = True
            continue
        if in_section:
            if stripped.startswith("#"):
                break
            if stripped:
                overview.append(stripped)
    if not overview:
        return f"{project_name} description to come"
    return " ".join(overview)
# -------------------------
# Logo lookup (HEAD check)
# -------------------------
def find_logo_url(dir_path: Path, nologo: bool, branch: str) -> str:
    name = dir_path.name
    # Use branch for asset if needed, but since assets are static, ignore branch here
    logo = f"{ASSETS_BASE}/{name}.png"
    default = f"{ASSETS_BASE}/default.png"
    if nologo:
        return default
    try:
        r = requests.head(logo, timeout=4)
        if r.status_code == 200:
            return logo
    except Exception:
        pass
    return default
# -------------------------
# Parse environment variables from sample.env/env-sample
# -------------------------
def parse_env_vars(dir_path: Path) -> List[Dict[str,str]]:
    candidates = [dir_path / "sample.env", dir_path / "env-sample"]
    env_file = None
    for c in candidates:
        if c.exists():
            env_file = c
            break
    if not env_file:
        return []
    out = []
    for raw in read_text_safe(env_file).splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            key, val = line.split("=", 1)
            key = key.strip()
            # strip inline comment after #
            val = val.split("#", 1)[0].strip()
            val = val.strip().strip('"').strip("'")
            out.append({"name": key, "default": val})
    return out
# -------------------------
# Build Portainer template object
# -------------------------
def generate_template_object(dir_path: Path, branch: str, nologo: bool, template_id: int) -> Dict:
    name = dir_path.name
    readme_path = dir_path / "README.md"
    env_vars = parse_env_vars(dir_path)
    obj = {
        "id": template_id,  # Unique ID for v3 format
        "type": 3,
        "title": name,
        "name": name,
        "note": "Auto-generated template from repository",
        "categories": ["Auto"],
        "platform": "linux",
        "logo": find_logo_url(dir_path, nologo=nologo, branch=branch),
        "description": extract_overview(readme_path, name),
        # Git repository for Compose stack
        "repository": {
            "url": f"https://github.com/{GITHUB_OWNER}/{GITHUB_REPO}",
            "stackfile": f"{name}/docker-compose.yml"
        }
    }
    # env
    env_entries = []
    for v in env_vars:
        if not v.get("name"):
            continue
        env_entries.append({
            "name": v["name"],
            "label": v["name"],
            "default": v.get("default","")
        })
    if env_entries:
        obj["env"] = env_entries
    return obj
# -------------------------
# Main
# -------------------------
def main():
    parser = argparse.ArgumentParser(description="Generate Portainer templates.json from compose cookbooks")
    parser.add_argument("--nologo", action="store_true", help="Skip HEAD check for logos (faster)")
    parser.add_argument("--branch", default=DEFAULT_BRANCH, help="Git branch to use for logo lookup (default: master). Templates use repo default branch.")
    parser.add_argument("--output", default=str(DEFAULT_OUTPUT), help="Output path for templates.json")
    parser.add_argument("--no-skip-volpath", action="store_true", help="Don't skip projects containing ${VOL_PATH")
    args = parser.parse_args()
    out_path = Path(args.output).resolve()
    branch = args.branch
    nologo = args.nologo
    skip_volpath = not args.no_skip_volpath
    templates = []
    skipped = []
    errored = []
    template_counter = 1  # Start ID from 1
    for item in sorted(REPO_ROOT.iterdir()):
        if not item.is_dir():
            continue
        if item.name.startswith("_"):
            continue
        if item.name.endswith(("_dev", "_notes")):
            continue
        compose_path = item / "docker-compose.yml"
        if not compose_path.exists():
            continue
        text = read_text_safe(compose_path)
        if skip_volpath and SKIP_VOLPATH_PATTERN in text:
            skipped.append((item.name, "uses ${VOL_PATH}"))
            continue
        try:
            tpl = generate_template_object(item, branch=branch, nologo=nologo, template_id=template_counter)
            templates.append(tpl)
            template_counter += 1
        except Exception as e:
            errored.append((item.name, str(e)))
    output = {"version": "3", "templates": templates}
    # write atomic
    write_atomic(out_path, json.dumps(output, indent=2))
    print(f"Generated {out_path} with {len(templates)} templates (v3 format with IDs).")
    if skipped:
        print("Skipped projects:")
        for n, reason in skipped:
            print(f" - {n}: {reason}")
    if errored:
        print("Errored projects:")
        for n, err in errored:
            print(f" - {n}: {err}")
if __name__ == "__main__":
    main()
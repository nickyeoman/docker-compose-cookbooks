#!/usr/bin/env python3
"""
Portainer templates generator for nickyeoman/docker-compose-cookbooks

Generates templates.json (Portainer-compatible) based on each project's
docker-compose.yml and sample.env/env-sample.

Behavior:
 - Uses master branch for raw GitHub stackfile URLs.
 - Skips directories starting with "_" and those ending with "_dev" or "_notes".
 - Skips projects whose docker-compose.yml contains "${VOL_PATH".
 - Extracts README "## Overview" (exact match) for the description; default fallback.
 - Parses sample.env or env-sample, strips inline comments, returns defaults.
 - Resolves image lines (handles ${VAR:-default} and ${VAR}) using sample.env defaults.
 - Parses ports into strings like "8000:80" or "8080:8080/tcp" for Portainer.
 - Parses volumes and converts them into named Docker volumes:
     - container path used as container
     - named volume created as "<stack>-<container-path-sanitized>" and inserted into "bind"
 - Produces a Portainer-friendly JSON structure:
     {
       "version": "3",
       "templates": [
         {
           "type": "docker-compose",
           "title": "<project>",
           "name": "<project>",
           "note": "...",
           "categories": ["Auto"],
           "platform": "linux",
           "logo": "...",
           "description": "...",
           "image": "...",
           "stackfile": "https://raw.githubusercontent.com/..../master/<project>/docker-compose.yml",
           "env": [ {name,label,default}, ... ],
           "ports": ["80:80", ...],
           "volumes": [ {"container":"/path", "bind":"<named-volume>"}, ... ]
         }
       ]
     }
"""
from pathlib import Path
import argparse
import json
import re
import requests
import sys

# Constants
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
OUTPUT_FILE = REPO_ROOT / "templates.json"
GITHUB_RAW_BASE = "https://raw.githubusercontent.com/nickyeoman/docker-compose-cookbooks/master"
ASSETS_BASE = "https://i.4lt.ca/cookbook"
SKIP_PAT = "${VOL_PATH"

# -------------------------
# Helpers
# -------------------------
def read_text_safe(p: Path) -> str:
    try:
        return p.read_text()
    except Exception:
        return ""

# -------------------------
# Extract "Overview" section from README.md (exact "## Overview")
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
# Logo URL lookup (skip HEAD if nologo True)
# -------------------------
def find_logo_url(dir_path: Path, nologo: bool = False) -> str:
    name = dir_path.name
    logo_url = f"{ASSETS_BASE}/{name}.png"
    default = f"{ASSETS_BASE}/default.png"
    if nologo:
        return default
    try:
        resp = requests.head(logo_url, timeout=4)
        if resp.status_code == 200:
            return logo_url
    except Exception:
        pass
    return default

# -------------------------
# Parse env defaults from sample.env or env-sample (strip comments)
# Returns list of dicts { "name": ..., "default": ... }
# -------------------------
def parse_env_vars(dir_path: Path):
    candidates = [dir_path / "sample.env", dir_path / "env-sample"]
    env_file = None
    for p in candidates:
        if p.exists():
            env_file = p
            break
    if not env_file:
        return []

    env_list = []
    for raw in read_text_safe(env_file).splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            key, val = line.split("=", 1)
            key = key.strip()
            # strip inline comments after #
            val = val.split("#", 1)[0].strip()
            # remove surrounding quotes
            val = val.strip().strip('"').strip("'")
            env_list.append({"name": key, "default": val})
    return env_list

# -------------------------
# Resolve the first "image:" line from docker-compose.yml
# Supports ${VAR:-default} and ${VAR}
# -------------------------
VAR_RE = re.compile(r"\$\{([^:}]+)(?:[:-]([^}]+))?\}")

def parse_image(compose_path: Path, env_vars: list) -> str:
    text = read_text_safe(compose_path)
    if not text:
        return ""

    env_defaults = {v["name"]: v["default"] for v in env_vars}

    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("image:"):
            image = stripped.split("image:", 1)[1].strip().strip('"').strip("'")
            # replace ${VAR:-default} or ${VAR} using env_defaults
            def repl(m):
                var = m.group(1)
                default = m.group(2)
                return env_defaults.get(var, default or "")
            image = VAR_RE.sub(repl, image)
            return image
    return ""

# -------------------------
# Parse ports into a list of strings Portainer likes
# Examples supported:
#   - "8080:80"
#   - "9000"
#   - "9000:9000/tcp"
#   - "53:53/udp"
# -------------------------
def parse_ports(compose_path: Path):
    text = read_text_safe(compose_path)
    if not text:
        return []

    ports = []
    lines = text.splitlines()
    in_ports = False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("ports:"):
            in_ports = True
            continue
        if in_ports:
            if not stripped or not stripped.startswith("-"):
                break
            # get port string, strip comments/quotes
            port_str = stripped[1:].strip().split("#", 1)[0].strip().strip('"').strip("'")
            if not port_str:
                continue
            # normalize space
            port_str = port_str.replace(" ", "")
            # handle protocol suffix; keep as-is for Portainer
            ports.append(port_str)
    return ports

# -------------------------
# Parse volumes:
# - Accept mapping forms:
#     host:container[:ro|rw]
#     container[:ro|rw]
#     named-volume:container[:ro|rw]
# - For Portainer templates we'll provide:
#     {"container": "/path/in/container", "bind": "<named-volume>"}
#   where <named-volume> is generated as "<stack>-<container-path-sanitized>"
# -------------------------
def parse_volumes(compose_path: Path, stack_name: str):
    text = read_text_safe(compose_path)
    if not text:
        return []

    vols = []
    lines = text.splitlines()
    in_volumes = False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("volumes:"):
            in_volumes = True
            continue
        if in_volumes:
            if not stripped or not stripped.startswith("-"):
                break
            vol_line = stripped[1:].strip().split("#", 1)[0].strip().strip('"').strip("'")
            if not vol_line:
                continue
            # split from right to handle host:container:mode (we want container and ignore host)
            parts = vol_line.rsplit(":", 2)  # at most 3 parts
            # container part is last if there are 2 or more parts, else first
            if len(parts) == 1:
                container_path = parts[0].strip()
            else:
                container_path = parts[-2].strip() if len(parts) == 3 else parts[-1].strip()
                # explanation:
                # - "host:container" -> parts len 2 -> parts[-1] == container
                # - "host:container:ro" -> parts len 3 -> parts[-2] == container
            # final strip of mode suffix if any left
            container_path = re.sub(r":(ro|rw)$", "", container_path)
            # ensure container path starts with /
            if not container_path.startswith("/"):
                # if it's like "config.yaml" or similar, prefix with /
                container_path = "/" + container_path.lstrip("/")

            # generate a safe named volume
            safe = container_path.strip("/").replace("/", "-").replace(".", "-")
            if not safe:
                safe = "data"
            vol_name = f"{stack_name}-{safe}"
            vols.append({"container": container_path, "bind": vol_name})
    return vols

# -------------------------
# Build a Portainer template object for a project directory
# -------------------------
def generate_template_object(dir_path: Path, nologo: bool = False):
    name = dir_path.name
    compose_file = dir_path / "docker-compose.yml"
    readme_file = dir_path / "README.md"

    description = extract_overview(readme_file, name)
    logo = find_logo_url(dir_path, nologo=nologo)
    env_vars = parse_env_vars(dir_path)
    image = parse_image(compose_file, env_vars)
    ports = parse_ports(compose_file)
    volumes = parse_volumes(compose_file, name)

    # env entries: only include those with a name
    env_entries = []
    for v in env_vars:
        if not v.get("name"):
            continue
        # leave default as empty string if missing (Portainer accepts empty)
        env_entries.append({"name": v["name"], "label": v["name"], "default": v.get("default", "")})

    # Build stackfile raw URL on master branch
    stackfile_url = f"{GITHUB_RAW_BASE}/{name}/docker-compose.yml"

    tpl = {
        "type": "docker-compose",
        "title": name,
        "name": name,
        "note": "Auto-generated template from repository",
        "categories": ["Auto"],
        "platform": "linux",
        "logo": logo,
        "description": description,
        # optional convenience field: image
        "image": image,
        # Portainer expects a full stackfile URL
        "stackfile": stackfile_url,
        "env": env_entries,
    }

    # ports: Portainer accepts list of strings like "8000:80" or "53:53/udp"
    if ports:
        tpl["ports"] = ports

    # volumes: produce list of objects with container and bind (named volume)
    if volumes:
        tpl["volumes"] = volumes

    return tpl

# -------------------------
# Main
# -------------------------
def main():
    parser = argparse.ArgumentParser(description="Generate Portainer templates.json from compose cookbooks")
    parser.add_argument("--nologo", action="store_true", help="skip HEAD requests for logos (faster, dev)")
    args = parser.parse_args()

    templates = []

    for item in REPO_ROOT.iterdir():
        if not item.is_dir():
            continue
        if item.name.startswith("_"):
            continue
        if item.name.endswith(("_dev", "_notes")):
            continue

        compose_path = item / "docker-compose.yml"
        if not compose_path.exists():
            continue

        # skip projects still using VOL_PATH (developer needs to fix)
        if SKIP_PAT in read_text_safe(compose_path):
            print(f"Skipping {item.name}: still uses ${{VOL_PATH}}")
            continue

        tpl = generate_template_object(item, nologo=args.nologo)
        templates.append(tpl)

    output = {"version": "3", "templates": templates}
    # Write atomically if possible
    tmp = OUTPUT_FILE.with_suffix(".tmp")
    tmp.write_text(json.dumps(output, indent=2))
    tmp.replace(OUTPUT_FILE)
    print(f"Generated {OUTPUT_FILE} with {len(templates)} templates.")

if __name__ == "__main__":
    main()

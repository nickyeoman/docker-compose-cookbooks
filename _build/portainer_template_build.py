#!/usr/bin/env python3
import os
import json
import re
from pathlib import Path

# ---------------------------------------------------------
# Paths
# ---------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
OUTPUT_FILE = REPO_ROOT / "templates.json"

# ---------------------------------------------------------
# Extract "Overview" section from README.md
# ---------------------------------------------------------
def extract_overview(readme_path: Path) -> str:
    if not readme_path.exists():
        return ""

    lines = readme_path.read_text().splitlines()
    overview = []
    in_section = False

    for line in lines:
        if line.strip().lower().startswith("## overview"):
            in_section = True
            continue
        if in_section and line.strip().startswith("## "):
            break
        if in_section:
            if line.strip():
                overview.append(line.strip())

    return " ".join(overview)

# ---------------------------------------------------------
# Logo URL mapping
# ---------------------------------------------------------
def find_logo_url(dir_path: Path) -> str:
    name = dir_path.name
    return f"https://i.4lt.ca/cookbook/{name}.png"

# ---------------------------------------------------------
# Parse first image name from docker-compose.yml
# Handles Bash-style defaults like ${VAR:-default}
# ---------------------------------------------------------
def parse_image(compose_path: Path) -> str:
    if not compose_path.exists():
        return ""

    for line in compose_path.read_text().splitlines():
        if "image:" in line:
            image = line.split("image:", 1)[1].strip().strip('"').strip("'")
            # Handle Bash-style ${VAR:-default} -> default
            match = re.match(r"\$\{[^:]+:-([^}]+)\}", image)
            if match:
                image = match.group(1)
            return image

    return ""

# ---------------------------------------------------------
# Parse environment variables from sample.env or env-sample
# ---------------------------------------------------------
def parse_env_vars(dir_path: Path):
    env_file = None

    if (dir_path / "sample.env").exists():
        env_file = dir_path / "sample.env"
    elif (dir_path / "env-sample").exists():
        env_file = dir_path / "env-sample"

    if not env_file:
        return []

    env_list = []
    for line in env_file.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            key = line.split("=", 1)[0].strip()
            if key:
                env_list.append(key)

    return env_list

# ---------------------------------------------------------
# Build template object for a stack directory
# ---------------------------------------------------------
def generate_template_object(dir_path: Path):
    name = dir_path.name
    compose_file = dir_path / "docker-compose.yml"
    readme_file = dir_path / "README.md"

    description = extract_overview(readme_file)
    if not description.strip():
        description = f"{name} Docker Compose stack"

    logo = find_logo_url(dir_path)
    image = parse_image(compose_file)
    env_vars = parse_env_vars(dir_path)

    env_entries = [
        {"name": v, "label": v, "default": ""} for v in env_vars
    ]

    return {
        "type": 1,
        "title": name,
        "description": description,
        "note": "Auto-generated template from repository",
        "categories": ["Auto"],
        "platform": "linux",
        "logo": logo,
        "image": image,
        "repository": {
            "url": "https://github.com/nickyeoman/docker-compose-cookbooks",
            "stackfile": f"{name}/docker-compose.yml",
            "stackfile_plain": False
        },
        "env": env_entries
    }

# ---------------------------------------------------------
# Main script logic
# ---------------------------------------------------------
def main():
    templates = []

    for item in REPO_ROOT.iterdir():
        if not item.is_dir():
            continue
        if item.name.startswith("_"):
            continue
        if not (item / "docker-compose.yml").exists():
            continue

        templates.append(generate_template_object(item))

    # Wrap in Portainer top-level object
    output_data = {
        "version": "3",
        "templates": templates
    }

    OUTPUT_FILE.write_text(json.dumps(output_data, indent=2))
    print(f"Generated {OUTPUT_FILE} with templates for Docker Compose stacks.")

if __name__ == "__main__":
    main()

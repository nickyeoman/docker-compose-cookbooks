#!/usr/bin/env python3
import os
import json
import re
import requests
from pathlib import Path

# ---------------------------------------------------------
# Paths
# ---------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
OUTPUT_FILE = REPO_ROOT / "templates.json"

# ---------------------------------------------------------
# Extract "Overview" section from README.md (strict)
# ---------------------------------------------------------
def extract_overview(readme_path: Path, project_name: str) -> str:
    if not readme_path.exists():
        return f"{project_name} description to come"

    lines = readme_path.read_text().splitlines()
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

# ---------------------------------------------------------
# Logo URL mapping with existence check
# ---------------------------------------------------------
def find_logo_url(dir_path: Path, nologo: bool = False) -> str:
    base_url = "https://i.4lt.ca/cookbooks/"
    name = dir_path.name
    logo_url = f"{base_url}{name}.png"

    if nologo:
        return f"{base_url}default.png"

    try:
        resp = requests.head(logo_url, timeout=5)
        if resp.status_code == 200:
            return logo_url
    except requests.RequestException:
        pass

    return f"{base_url}default.png"

# ---------------------------------------------------------
# Parse image from docker-compose.yml using sample.env defaults
# ---------------------------------------------------------
def parse_image(compose_path: Path, env_vars: list) -> str:
    if not compose_path.exists():
        return ""

    env_defaults = {v["name"]: v["default"] for v in env_vars}

    for line in compose_path.read_text().splitlines():
        line = line.strip()
        if line.startswith("image:"):
            image = line.split("image:", 1)[1].strip().strip('"').strip("'")

            # Handle ${VAR:-default} or ${VAR}
            def replace_var(match):
                var_name = match.group(1)
                bash_default = match.group(2)
                return env_defaults.get(var_name, bash_default if bash_default else "")

            image = re.sub(r"\$\{([^:}]+)(?:[:-]([^}]+))?\}", replace_var, image)
            return image

    return ""

# ---------------------------------------------------------
# Parse ports from docker-compose.yml
# Returns a list of dicts: {"container": port, "published": port, "protocol": "tcp"}
# ---------------------------------------------------------
def parse_ports(compose_path: Path):
    if not compose_path.exists():
        return []

    ports_list = []
    lines = compose_path.read_text().splitlines()
    in_ports = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("ports:"):
            in_ports = True
            continue
        if in_ports:
            if not stripped or not stripped.startswith("-"):
                break

            port_str = stripped[1:].strip().split("#", 1)[0].strip().strip('"').strip("'")
            if not port_str:
                continue

            protocol = "tcp"
            if "/" in port_str:
                port_part, protocol_part = port_str.split("/", 1)
                protocol = protocol_part.strip()
            else:
                port_part = port_str

            if ":" in port_part:
                host_port, container_port = port_part.split(":", 1)
            else:
                container_port = port_part
                host_port = container_port

            try:
                container_port = int(container_port.strip())
                host_port = int(host_port.strip())
            except ValueError:
                continue

            ports_list.append({
                "container": container_port,
                "published": host_port,
                "protocol": protocol
            })

    return ports_list

# ---------------------------------------------------------
# Parse volumes from docker-compose.yml
# Returns a list of dicts: {"name": "unique-name", "container": "/container/path"}
# ---------------------------------------------------------
def parse_volumes(compose_path: Path, stack_name: str):
    """
    Parse volumes from docker-compose.yml and generate Portainer-ready entries.
    Host paths and VOL_PATH references are ignored; only container paths are used.
    """
    if not compose_path.exists():
        return []

    volumes = []
    lines = compose_path.read_text().splitlines()
    in_volumes = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("volumes:"):
            in_volumes = True
            continue
        if in_volumes:
            if not stripped or not stripped.startswith("-"):
                break

            # Strip "- ", quotes, inline comments
            volume_str = stripped[1:].strip().split("#", 1)[0].strip().strip('"').strip("'")
            if not volume_str:
                continue

            # Split host:container[:ro|rw]
            parts = volume_str.split(":")
            if len(parts) == 1:
                container_path = parts[0].strip()
            else:
                container_path = parts[-1].strip()  # always take the last part as container path

            # Remove :ro or :rw suffix if present
            container_path = re.sub(r":(ro|rw)$", "", container_path)

            # Generate unique name for Portainer from stack + container path
            name = f"{stack_name}-{container_path.strip('/').replace('/', '-')}"
            if not name:
                name = f"{stack_name}-volume"

            volumes.append({"name": name, "container": container_path})

    return volumes

# ---------------------------------------------------------
# Parse environment variables from sample.env or env-sample
# Returns a list of dicts: {"name": ..., "default": ...}
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
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.split("#", 1)[0].strip().strip('"').strip("'")
            if key:
                env_list.append({"name": key, "default": value})

    return env_list

# ---------------------------------------------------------
# Build template object for a stack directory
# ---------------------------------------------------------
def generate_template_object(dir_path: Path, nologo: bool = False):
    name = dir_path.name
    compose_file = dir_path / "docker-compose.yml"
    readme_file = dir_path / "README.md"

    description = extract_overview(readme_file, name)
    logo = find_logo_url(dir_path, nologo=False)
    env_vars = parse_env_vars(dir_path)
    image = parse_image(compose_file, env_vars)
    ports = parse_ports(compose_file)
    volumes = parse_volumes(compose_file, name)

    env_entries = [
        {"name": v["name"], "label": v["name"], "default": v["default"]}
        for v in env_vars if v["default"] is not None
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
        "env": env_entries,
        "ports": ports,
        "volumes": volumes
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
        if item.name.endswith(("_dev", "_notes")):
            continue

        compose_path = item / "docker-compose.yml"
        if not compose_path.exists():
            continue

        # ---------------------------------------------
        # Skip stacks still using ${VOL_PATH
        # ---------------------------------------------
        compose_text = compose_path.read_text()
        if "${VOL_PATH" in compose_text:
            continue

        # ---------------------------------------------
        # Generate Portainer template object
        # ---------------------------------------------
        templates.append(generate_template_object(item, nologo=True))

    # Write output file
    output_data = {
        "version": "3",
        "templates": templates
    }

    OUTPUT_FILE.write_text(json.dumps(output_data, indent=2))
    print(f"Generated {OUTPUT_FILE} with templates for Docker Compose stacks.")


if __name__ == "__main__":
    main()

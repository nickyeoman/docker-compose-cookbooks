#!/usr/bin/env python3
"""Convention linter for this repo — run: python3 _docs/lint.py

Checks every stack (skipping _notes dirs) against the conventions in AGENTS.md:
required files, compose section order, VOL_PATH defaults, TZ default, proxy
network, no healthchecks, env-configurable image/restart/port, README section
order and completeness, and compose <-> sample.env consistency.

Exit code 1 if any errors are found. Stale sample.env vars are warnings only.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SECTION_ORDER = ["image", "restart", "volumes", "environment", "ports",
                 "networks", "depends_on", "healthcheck", "labels", "command", "user"]
README_ORDER = ["Overview", "Project Details", "Getting Started",
                "Environment Variable Notes", "Volume Notes", "Network Notes",
                "Docker Run", "Additional Notes / Gotchas",
                "Dockhand Stack, Deploy from Git"]
UNIVERSAL_VARS = {"VOL_PATH", "VOL_PROJECTS", "TZ", "CONFIG_PATH", "LOG_PATH"}

# Known exceptions — see AGENTS.md "Known exceptions"
NO_PROXY_OK = {"pihole"}
HARDCODED_RESTART_OK = {("zammad_dev", "on-failure")}
STALE_VARS_OK = {
    "mailu_dev": None,  # env_file: .env — all vars consumed in-container
    "headscale_dev": {"HEADSCALE_DOMAIN", "HEADSCALE_URL"},  # config-file docs
}

errors = []
warnings = []


def err(stack, msg):
    errors.append(f"{stack}: {msg}")


def warn(stack, msg):
    warnings.append(f"{stack}: WARNING: {msg}")


def check_compose(stack, path):
    c = open(path).read()
    if "\t" in c:
        err(stack, "compose.yaml contains tab characters")
    if not re.search(r"^networks:\n(?:.*\n)*?\s+proxy:\n\s+external:\s*true", c, re.M):
        if stack not in NO_PROXY_OK:
            err(stack, "proxy network not declared external:true at root")
    if re.search(r"^\s+healthcheck:", c, re.M):
        err(stack, "contains healthcheck block (healthchecks are a future feature)")
    for m in re.finditer(r"^\s*-\s*(\./[^\s:]*):", c, re.M):
        err(stack, f"relative volume path: {m.group(1)}")
    if re.search(r"\$\{VOL_PATH\}", c):
        err(stack, "VOL_PATH used without :-/data default")
    if re.search(r"VOL_PATH:-(?!/data\})", c):
        err(stack, "VOL_PATH default is not /data")
    for m in re.finditer(r"TZ:-([^}\s]+)", c):
        if m.group(1) != "America/Vancouver":
            err(stack, f"TZ default is {m.group(1)}, expected America/Vancouver")
    for m in re.finditer(r"^\s+restart:\s*(.+)$", c, re.M):
        val = m.group(1).strip()
        if "${" not in val and (stack, val) not in HARDCODED_RESTART_OK:
            err(stack, f"restart not env-configurable: {val}")
    for m in re.finditer(r"^\s+image:\s*(.+)$", c, re.M):
        if "${" not in m.group(1):
            err(stack, f"image not env-configurable: {m.group(1).strip()}")
    in_ports = False
    for line in c.splitlines():
        if re.match(r"^\s+ports:", line):
            in_ports = True
            continue
        if in_ports:
            if re.match(r"^\s+-\s", line):
                if "${" not in line:
                    err(stack, f"port not env-configurable: {line.strip()}")
            else:
                in_ports = False
    # per-service section order
    cur_svc, cur_keys, in_services = None, [], False

    def flush():
        if cur_svc and cur_keys:
            idx = [SECTION_ORDER.index(k) for k in cur_keys if k in SECTION_ORDER]
            if idx != sorted(idx):
                err(stack, f"service '{cur_svc}' section order: {cur_keys}")

    for line in c.splitlines():
        if re.match(r"^services:\s*$", line):
            in_services = True
            continue
        if in_services and re.match(r"^\S", line):
            in_services = False
        if not in_services:
            continue
        m = re.match(r"^(  )([A-Za-z0-9_-]+):\s*$", line)
        if m:
            flush()
            cur_svc, cur_keys = m.group(2), []
            continue
        m = re.match(r"^    ([a-z_]+):", line)
        if m and cur_svc:
            cur_keys.append(m.group(1))
    flush()
    return c


def check_readme(stack, path):
    r = open(path).read()
    heads = [h.strip() for h in re.findall(r"^#{1,3}\s+(.+)$", r, re.M)]
    norm = [x for h in heads for x in README_ORDER if x.lower() == h.lower()]
    idx = [README_ORDER.index(h) for h in norm]
    if idx != sorted(idx):
        err(stack, f"README section order off: {norm}")
    missing = [h for h in README_ORDER if h not in norm]
    if missing:
        err(stack, f"README missing sections: {missing}")


def check_env(stack, compose_text, env_path):
    envtext = open(env_path).read()
    used = set(re.findall(r"\$\{([A-Z0-9_]+)", compose_text))
    defined = set(re.findall(r"^\s*#?\s*([A-Z0-9_]+)=", envtext, re.M))
    missing = sorted(used - defined - UNIVERSAL_VARS)
    if missing:
        err(stack, f"compose vars missing from sample.env: {missing}")
    ok = STALE_VARS_OK.get(stack, set())
    if ok is None:
        return
    active = set(re.findall(r"^([A-Z0-9_]+)=", envtext, re.M))  # commented vars aren't stale
    stale = sorted((defined & active) - used - UNIVERSAL_VARS - ok)
    if stale:
        warn(stack, f"sample.env vars not used in compose: {stale}")
    for m in re.finditer(r'^TZ="', envtext, re.M):
        err(stack, "TZ value is quoted in sample.env (convention: unquoted)")


def main():
    for d in sorted(os.listdir(ROOT)):
        p = os.path.join(ROOT, d)
        if not os.path.isdir(p) or d.startswith((".", "_")):
            continue
        if d.endswith("_notes"):
            continue
        files = os.listdir(p)
        for req in ("compose.yaml", "sample.env", "README.md"):
            if req not in files:
                err(d, f"missing {req}")
        compose_text = ""
        if "compose.yaml" in files:
            compose_text = check_compose(d, os.path.join(p, "compose.yaml"))
        if "README.md" in files:
            check_readme(d, os.path.join(p, "README.md"))
        if compose_text and "sample.env" in files:
            check_env(d, compose_text, os.path.join(p, "sample.env"))

    for w in warnings:
        print(w)
    for e in errors:
        print(e)
    print(f"\n{len(errors)} errors, {len(warnings)} warnings")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()

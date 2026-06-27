# OpenClaw

## Overview

OpenClaw is an open-source AI coding assistant gateway with multi-model
support, agent sandboxing, and extensible plugin system.

## Project Details

-   **Project Repository:** [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)
-   **Container Image:** [ghcr.io/openclaw/openclaw](https://github.com/openclaw/openclaw/pkgs/container/openclaw)
-   **Documentation:** [docs.openclaw.ai](https://docs.openclaw.ai)
-   **Reverse Proxy Port:** `18789`

## Environment Variable Notes

-   `OPENCLAW_GATEWAY_TOKEN` — required shared secret for Control UI access.
    Generate with `openssl rand -hex 32`.
-   `OPENCLAW_GATEWAY_BIND` — `lan` (default, reachable from host) or `loopback`.
-   `OPENCLAW_DISABLE_BONJOUR` — set to `1` (default) for Docker bridge;
    `0` only on host/macvlan networks.
-   `OTEL_EXPORTER_OTLP_ENDPOINT` — optional OpenTelemetry collector URL.

## Volume Notes

-   `/home/node/.openclaw` — config, state, and installed plugins
-   `/home/node/.openclaw/workspace` — agent workspace files
-   `/home/node/.config/openclaw` — auth-profile secret encryption keys

All three use `${VOL_PATH:-/data}/openclaw/` as the host base path.

## Network Notes

Requires proxy network

## Additional Notes / Gotchas

-   This is a `_dev` stack — experimental, not yet production-ready.
-   The container runs as `node` (uid 1000). Ensure host bind-mount
    directories are owned by uid 1000 or set `user: "0:0"`.
-   Host-side AI providers (Ollama, LM Studio) are reachable at
    `http://host.docker.internal:<port>`.
-   CLI commands: `docker compose exec openclaw node dist/index.js <subcommand>`
-   Image includes built-in `HEALTHCHECK`; the compose file adds an explicit
    `curl`-based check.

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: openclaw_dev
-   Compose file path: openclaw_dev/compose.yaml
-   Additional env file (optional): openclaw_dev/sample.env

Then "Load" openclaw_dev/sample.env into the Environment variables in dockhand.

Create the Stack

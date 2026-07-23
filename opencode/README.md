# OpenCode

## Overview

OpenCode is an open source AI coding agent.

## Project Details

-   **Project Repository:** [opencode](https://github.com/anomalyco/opencode)
-   **Container Image:** [GitHub](https://github.com/anomalyco/opencode/pkgs/container/opencode)
-   **Documentation:** [Docs](https://opencode.ai/docs)
-   **Reverse Proxy Port:** `4096`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:4096 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    OPENCODE_PORT – default: 4096
    OPENCODE_HOSTNAME – default: 0.0.0.0

## Volume Notes

With `VOL_PATH=/data`:

| Container path | Host path | Purpose |
|---|---|---|
| `/config` | `/data/opencode/config` | Config files (config.json), also `$HOME` |
| `/data` | `/data/opencode/data` | OpenCode state, incl. `auth.json` from `/connect` |
| `/projects` | `/data/opencode/projects` | Workspace/project files |

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name opencode \
  -p 4096:4096 \
  -v /data/opencode/config:/config \
  -v /data/projects:/projects \
  ghcr.io/anomalyco/opencode:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

This is a shared, reusable compose file — it ships "ready to use" but not
pre-authenticated. Whoever runs it needs to `/connect` a provider (OpenCode
Zen or OpenCode Go) before the agent can actually make model calls. Because
`HOME` and `XDG_DATA_HOME` point at the `/data` bind mount, that login
persists across container recreation.

### Config file

The `config.json` at `opencode/config/config.json` is pre-configured to use
**OpenCode Zen** cloud models — no local model runtime required. Default
model is `opencode/deepseek-v4-flash-free` (free tier).

Run `/connect` inside the TUI to authenticate with OpenCode Zen (or another
provider) and `/models` to switch. Login is persisted to the `/data` bind
mount, so it survives container recreation.

For a flat-rate bundle of open-source models instead of pay-as-you-go, see
**OpenCode Go** ($10/mo subscription, ~12 models including DeepSeek V4,
Qwen 3.6, GLM 5.2) — switch to it the same way via `/connect` and `/models`.

To use a custom config with `VOL_PATH=/data`, copy it to:

```
/data/opencode/config/config.json
```

### Model Guides

See the `docs/` directory for best-practice guides on supported models:

- [DeepSeek V4 Flash Free](docs/DeepSeekV4FlashFree.md) — free model via opencode provider (default)
- [Claude (Anthropic)](docs/Claude.md) — paid model via API key

### CLI Cheatsheet

From the `opencode/` directory, prefix commands with `docker compose`:

```sh
# Start the web UI
docker compose up -d

# Attach TUI to the running server
docker compose exec opencode opencode

# Run a one-off command (replaces the "serve" command)
docker compose run --rm opencode opencode stats

# Common commands (via exec or run)
docker compose exec opencode opencode models --refresh
docker compose exec opencode opencode models
docker compose exec opencode opencode stats
docker compose exec opencode opencode stats --models --days 7
docker compose exec opencode opencode session list
docker compose exec opencode opencode auth list
docker compose exec opencode opencode db path
docker compose exec opencode opencode upgrade
```

### Inside the TUI

```
/init          # Analyze project, create AGENTS.md
/models        # Switch model
/connect       # Add API key for a provider
/undo          # Undo last change
/redo          # Redo undone change
/share         # Create share link
```

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: opencode
Compose file path: opencode/compose.yaml
Additional env file (optional): opencode/sample.env

Then "Load" opencode/sample.env into the Environmental variables in dockhand.

Create the Stack

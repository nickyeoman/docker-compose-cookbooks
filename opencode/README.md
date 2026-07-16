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
    OLLAMA_HOST_URL – default: http://localhost:11434

## Volume Notes

With `VOL_PATH=/data`:

| Container path | Host path | Purpose |
|---|---|---|
| `/config` | `/data/opencode/config` | Config files (config.json) |
| `/data` | `/data/opencode/data` | OpenCode state |
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

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: opencode
Compose file path: opencode/compose.yaml
Additional env file (optional): opencode/sample.env

Then "Load" opencode/sample.env into the Environmental variables in dockhand.

Create the Stack

## Config file

The `config.json` at `opencode/config/config.json` is pre-configured for
Ollama. Available models include:

| Model | Default | Purpose |
|---|---|---|
| `qwen2.5-coder:14b` | default | Coding & agent tasks (recommended for this repo) |
| `qwen3:8b` / `qwen3:8b-16k` | | General purpose, tool support |
| `qwen2.5:7b` | | Lightweight general purpose |
| `mistral:latest` / `mistral-small3.2:latest` | | Chat & multilingual |
| `llama3.1:8b` | | General purpose |

Tested on an NVIDIA GeForce RTX 5060 Ti (16 GB VRAM).

## Model Guides

See the `docs/` directory for best-practice guides on each supported model:

- [DeepSeek V4 Flash Free](docs/DeepSeekV4FlashFree.md) — free model via opencode provider
- [Qwen3 8B 16k](docs/Qwen.md) — local model via Ollama
- [Claude (Anthropic)](docs/Claude.md) — paid model via API key

To use a custom config with `VOL_PATH=/data`, copy it to:

```
/data/opencode/config/config.json
```

## CLI Cheatsheet

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

## Ollama

This stack requires the [ollama](../ollama/) stack to be running. The config
connects to `http://localhost:11434/v1` inside the container.

To use a host-side ollama instead, set `OLLAMA_HOST=http://host.docker.internal:11434`.

## Environment Variables

-   `OPENCODE_SERVER_PASSWORD` — required. Set a strong password for the web UI.
-   `OLLAMA_HOST` — Ollama API endpoint (default `http://localhost:11434`)
-   `OPENCODE_PORT` — Web UI port (default `4096`)
-   `VOL_PATH` — Base path for persistent data (default `/data`)

# OpenCode

## Overview

OpenCode is an open source AI coding agent.

## Project Details

-   **Project Repository:** [opencode](https://github.com/anomalyco/opencode)
-   **Container Image:** [GitHub](https://github.com/anomalyco/opencode/pkgs/container/opencode)
-   **Documentation:** [Docs](https://opencode.ai/docs)
-   **Reverse Proxy Port:** `4096`

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

To use a custom config with `VOL_PATH=/data`, copy it to:

```
/data/opencode/config/config.json
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

## Volume Notes

With `VOL_PATH=/data`:

| Container path | Host path | Purpose |
|---|---|---|
| `/config` | `/data/opencode/config` | Config files (config.json) |
| `/data` | `/data/opencode/data` | OpenCode state |
| `/projects` | `/data/opencode/projects` | Workspace/project files |

## Network Notes

Requires proxy network

## dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: opencode
Compose file path: opencode/compose.yaml
Additional env file (optional): opencode/sample.env

Then "Load" opencode/sample.env into the Environmental variables in dockhand.

Create the Stack

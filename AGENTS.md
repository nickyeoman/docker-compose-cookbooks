# AGENTS.md

## Stack conventions

- Every stack has exactly 3 files: `compose.yaml` (or `docker-compose.yml`), `sample.env`, `README.md`
- `_dev` = experimental, `_notes` = docs/minimal examples, no suffix = production-ready
- Always references an external `proxy` network (`docker network create proxy` once)
- Volumes use `${VOL_PATH:-/data}` as the base path
- Timezone defaults to `America/Vancouver`
- Restart policy, image tag, and port are configurable via env vars with sensible defaults
- `deploy.bash` at root emulates Dockhand CLI for local testing (uses `fzf`)
- New stacks: copy from `_docs/template-compose.md` and `_docs/template-readme.md`
- Compose section order: `image` → `restart` → `volumes` → `environment` → `ports` → `networks` → `depends_on` → `healthcheck` → `labels` → `command` → `user`

## Test a single stack

```sh
# From the stack directory:
docker compose --env-file sample.env up -d
```

Note: `deploy.bash` only looks for `compose.yaml`, not `docker-compose.yml`.

## Environment loading

`--env-file` supports multiple files, applied in order (last wins):
```sh
docker compose --env-file sample.env --env-file /data/test.env up -d
```

## No CI/CD, no dependency management

This is a Docker Compose file collection, not a code project. No tests, no build tools, no lockfiles.

## OpenCode

The `opencode/` stack runs OpenCode with a local ollama backend. Config is at `opencode/config/config.json`. Requires `ollama/` stack to be running and `OPENCODE_SERVER_PASSWORD` to be set.

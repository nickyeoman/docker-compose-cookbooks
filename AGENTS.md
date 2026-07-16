# AGENTS.md

## Stack conventions

- Every stack has at least 3 files: `compose.yaml` (dockhand style), `sample.env`, `README.md`
- `_dev` = experimental, `_notes` = docs/minimal examples, no suffix = production-ready
- `_notes` stacks are exempt from all conventions below — they hold notes, example commands, or minimal compose files only
- Always references an external `proxy` network (managed by Nginx Proxy Manager; `docker network create proxy` once)
- Volumes use `${VOL_PATH:-/data}` as the base path (absolute `/data`, never `./data`); project directories use `${VOL_PROJECTS:-/data}`
- Timezone defaults to `America/Vancouver`, but only include if the container requires it.
- Restart policy, image tag, and port are configurable via env vars with sensible defaults
- New stacks: copy from `_docs/template-compose.md` and `_docs/template-readme.md`
- Compose section order: `image` → `restart` → `volumes` → `environment` → `ports` → `networks` → `depends_on` → `healthcheck` → `labels` → `command` → `user`
- Healthchecks are a future feature — do not add `healthcheck` blocks to stacks at this time (the section order above just reserves their place)
- README section order: `Overview` → `Project Details` → `Getting Started` → `Environment Variable Notes` → `Volume Notes` → `Network Notes` → `Docker Run` → `Additional Notes / Gotchas` → `Dockhand Stack, Deploy from Git`
- Every compose file must declare the external `proxy` network at the root level:
  ```yaml
networks:
    proxy:
      external: true
```
- Multi-service stacks also use a bridge network named `internal` (see `network.yml` at the repo root for the sample): databases and other backing services join `internal` only; the app service joins both `proxy` and `internal`
- Default secrets (passwords, keys, tokens) are always the literal `ChangeThisPassword` — same string everywhere so it is easy to grep. Users must change them; never ship a real-looking secret as a default
- Lint the repo with `python3 _docs/lint.py` before committing — it checks all of the conventions above

## Known exceptions

These deliberately violate the conventions above — do not "fix" them:

- `pihole` uses `network_mode: host` (it's a DNS server), so it has no `proxy` network
- `zammad_dev` `zammad-init` service hardcodes `restart: on-failure` (init container)
- `nextcloud/compose-aio.yaml` follows the upstream AIO layout: fixed container/volume names, no env templating, no proxy network
- `opencode` and `vscode` default `VOL_PROJECTS` to `${VOL_PATH:-/data}/projects` (nested default), not plain `/data`
- `mailu_dev` passes env via `env_file: .env`, so its sample.env holds vars the compose file never references
- `headscale_dev` sample.env documents `HEADSCALE_DOMAIN`/`HEADSCALE_URL` for the config file even though compose doesn't use them

## No CI/CD, no dependency management

This is a Docker Compose file collection, not a code project. No tests, no build tools, no lockfiles.


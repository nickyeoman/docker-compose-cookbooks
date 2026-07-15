# AGENTS.md

## Stack conventions

- Every stack has at least 3 files: `compose.yaml` (dockhand style), `sample.env`, `README.md`
- `_dev` = experimental, `_notes` = docs/minimal examples, no suffix = production-ready
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

## No CI/CD, no dependency management

This is a Docker Compose file collection, not a code project. No tests, no build tools, no lockfiles.


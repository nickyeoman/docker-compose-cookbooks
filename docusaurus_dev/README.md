# Docusaurus

## Overview

Docusaurus is an open source static site generator for building
documentation websites. This stack runs the Docusaurus dev server
directly from a `node` image against a project mounted from the host,
so you can scaffold and preview a docs site without installing Node
locally.

## Project Details

-   **Project Repository:** https://github.com/facebook/docusaurus
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/node)
-   **Compose Example:** N/A (no official Docusaurus image; this stack runs the CLI on top of `node`)
-   **Documentation:** [Docusaurus Docs](https://docusaurus.io/docs)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. On first run, with an empty volume, the container scaffolds a new
   classic Docusaurus site with `create-docusaurus` before starting
   the dev server — this can take a minute
3. Open http://localhost:3000 in your browser
4. Edit files under the mounted volume on the host; the dev server
   hot-reloads on changes

## Environment Variable Notes

-   `DOCUSAURUS_IMAGE` – Node image to run Docusaurus on (default: `node:20-alpine`)
-   `DOCUSAURUS_PORT` – Host port to expose the dev server on (default: `3000`)
-   `DOCUSAURUS_RESTART` – Restart policy (default: `unless-stopped`)

## Volume Notes

-   `/app` – Docusaurus project source (`docusaurus.config.js`, `docs/`,
    `package.json`, etc.); mounted from `${VOL_PATH:-/data}/docusaurus`
    so the site persists and is editable from the host. If this
    directory has no `package.json`, the container scaffolds a fresh
    classic-template site into it on startup.

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name=docusaurus \
  -e HOST=0.0.0.0 \
  -v /data/docusaurus:/app \
  -w /app \
  -p 3000:3000 \
  node:20-alpine \
  sh -c "apk add --no-cache git >/dev/null 2>&1 || true; [ -f package.json ] || npx --yes create-docusaurus@latest . classic --skip-install --package-manager npm; npm install; npm start -- --host 0.0.0.0"
```

## Additional Notes / Gotchas

-   This is a dev-server stack, not production hosting — it runs
    `npm start`, which serves an unoptimized, hot-reloading build.
    For production, build a static bundle (`npm run build`) and serve
    it from a static file server or CDN instead.
-   `npm install` runs on every container start, so the first start
    after scaffolding (and any restart) takes longer than subsequent
    ones once `node_modules` is cached in the volume.
-   Because the entire project lives in the bind-mounted volume,
    deleting the volume wipes the docs site along with it — back it up
    like any other source tree.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: docusaurus
Compose file path: docusaurus_dev/compose.yaml
Additional env file (optional): docusaurus_dev/sample.env

Then "Load" docusaurus_dev/sample.env into the Environmental variables in dockhand

Create the Stack

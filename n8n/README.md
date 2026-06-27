# n8n

It means "nodemation" and it is pronounced as n-eight-n.
Free and open fair-code licensed node based Workflow Automation Tool.

## Overview

Docker Compose setup for [n8n](https://n8n.io/), a workflow automation tool.

## Project Details

-   **Project Repository:** [n8n on GitHub](https://github.com/n8n-io/n8n)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/n8nio/n8n)
-   **Compose Example:** [n8n Docker Compose docs](https://docs.n8n.io/hosting/installation/server-setups/docker-compose/#5-create-docker-compose-file)
-   **Documentation:** [n8n Docs](https://docs.n8n.io/)
-   **Docker Hub Tags:** [Tags](https://hub.docker.com/r/n8nio/n8n/tags)
-   **Reverse Proxy Port:** `5678`

## Environment Variable Notes

    N8N_IMAGE – Docker image tag (default: n8nio/n8n:latest)
    N8N_PORT – Container port (default: 5678)
    N8N_HOST – Hostname for the n8n instance (default: localhost)
    N8N_PROTOCOL – Protocol (default: http; set to https behind NPM)
    N8N_EDITOR_BASE_URL – Public-facing editor URL (default: http://localhost:5678)
    N8N_SECURE_COOKIE – Set true when using HTTPS (default: true)
    WEBHOOK_URL – Public-facing webhook URL (default: http://localhost:5678)

## Reverse Proxy Setup (Nginx Proxy Manager)

1. In NPM, create a **Proxy Host**:
   - **Domain Names:** `n8n.yourdomain.com`
   - **Forward Hostname:** `n8n`
   - **Forward Port:** `5678`
   - **Scheme:** `http`
   - **Websockets Support:** ✔ Enabled
   - **Block Common Exploits:** ✔ Enabled
   - **SSL:** ✔ Enable SSL (Let's Encrypt)

2. Override these env vars:

       N8N_HOST=n8n.yourdomain.com
       N8N_PROTOCOL=https
       N8N_EDITOR_BASE_URL=https://n8n.yourdomain.com
       WEBHOOK_URL=https://n8n.yourdomain.com
       N8N_SECURE_COOKIE=true

## Volume Notes

    ${VOL_PATH}/n8n/data – n8n database and config (chown 1000:1000)
    ${VOL_PATH}/n8n/files – shared file storage for workflows

## Network Notes

Requires the external `proxy` network.

## Additional Notes / Gotchas

- A license key is required (free at the time of writing).
- First load will ask for an admin account.
- Setup data directory:

      mkdir -p data/n8n/
      chown -R 1000:1000 data/

## Dockhand Stack, Deploy from Git

Cookbooks Repository

    stackname: n8n
    Compose file path: n8n/compose.yaml
    Additional env file (optional): n8n/sample.env

Then "Load" n8n/sample.env into the Environmental variables in dockhand

Create the Stack

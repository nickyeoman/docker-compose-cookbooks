# Paisa

## Overview

Paisa is a self-hosted personal finance manager built on top of the
plain-text `ledger` accounting format, with a web UI for dashboards,
budgets, and transaction management.

## Project Details

-   **Project Repository:** [github.com/ananthakumaran/paisa](https://github.com/ananthakumaran/paisa)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/ananthakumaran/paisa)
-   **Documentation:** [paisa.fyi](https://paisa.fyi/)
-   **Reverse Proxy Port:** `7500`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:7500 in your browser
3. Configure your ledger journal and accounts via the web UI

## Environment Variable Notes

    PAISA_IMAGE – container image (default ananthakumaran/paisa:latest)
    PAISA_RESTART – restart policy (default unless-stopped)
    VOL_PATH – host base path for volumes (default /data)
    PAISA_PORT – host port for the web UI (default 7500)

## Volume Notes

-   `/root/Documents/paisa` — ledger journal, config, and database;
    stored at `${VOL_PATH:-/data}/paisa` on the host

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name=paisa \
  -p 7500:7500 \
  -v /data/paisa:/root/Documents/paisa \
  ananthakumaran/paisa:latest
```

## Additional Notes / Gotchas

-   This is a `_dev` stack — experimental, not yet production-ready.
-   The container runs as root and stores everything under
    `/root/Documents/paisa`; back up that directory to preserve your
    ledger data.

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: paisa_dev
-   Compose file path: paisa_dev/compose.yaml
-   Additional env file (optional): paisa_dev/sample.env

Then "Load" paisa_dev/sample.env into the Environment variables in dockhand.

Create the Stack

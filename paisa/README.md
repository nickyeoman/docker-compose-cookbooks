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

1. Copy this stack's `config/` folder to `${VOL_PROJECTS:-/data}/paisa`
   and make it a git repo. It holds `paisa.yaml`, an empty `main.ledger`,
   `sheets/`, and a `.gitignore`. Edit `paisa.yaml` to suit you.
   Starting a new business? Copy `template/` instead: it has a chart of
   accounts for a small BC corporation and commented example entries.
   Fill in its `TODO`s.
2. Deploy the stack. Paisa creates `paisa.db` in `${VOL_PATH:-/data}/paisa`.
3. Open http://localhost:7500 in your browser.

To explore first, see [docs/demo.md](docs/demo.md) for the sample books of
Demolition Company Ltd. For ledger syntax, see
[docs/ledger-cheatsheet.md](docs/ledger-cheatsheet.md). Accountants new to
Paisa should read [docs/paisa-for-accountants.md](docs/paisa-for-accountants.md),
especially the section on closing entries.

## Environment Variable Notes

    PAISA_IMAGE – container image (default ananthakumaran/paisa:latest)
    PAISA_RESTART – restart policy (default unless-stopped)
    VOL_PATH – host base path for the database, backed up by restic (default /data)
    VOL_PROJECTS – host base path for the ledger git repo (default /data)
    PAISA_PORT – host port for the web UI (default 7500)

## Volume Notes

Anything that belongs in git goes in `VOL_PROJECTS`; anything that
doesn't (the SQLite database) goes in `VOL_PATH`, which is backed up.

-   `/root/Documents/paisa` — `paisa.yaml`, `*.ledger`, `sheets/`;
    `${VOL_PROJECTS:-/data}/paisa` on the host, kept in git
-   `/var/lib/paisa` — `paisa.db`; `${VOL_PATH:-/data}/paisa` on the
    host, backed up by restic

Both default to `/data`, so they start out as the same folder. Change
them in the stack's env in Dockhand to split them.

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name=paisa \
  -p 7500:7500 \
  -v /data/paisa:/root/Documents/paisa \
  -v /data/paisa:/var/lib/paisa \
  ananthakumaran/paisa:latest
```

## Additional Notes / Gotchas

-   If Paisa finds no `paisa.yaml`, it creates one with Indian defaults
    (INR, en-IN, fiscal year starting in April), so copy `config/` in first.
-   `db_path: /var/lib/paisa/paisa.db` in `paisa.yaml` is what keeps the
    database out of git. Keep it if you write your own config.
-   With the default `/data` for both, `paisa.db` sits in the git folder;
    the shipped `.gitignore` keeps it out of commits. Existing single-folder
    installs keep working, since `/var/lib/paisa/paisa.db` is the same file.
-   `config/paisa.yaml` uses CAD, en-US number formatting,
    America/Vancouver, a January fiscal year, and no login. Add
    `user_accounts` before exposing Paisa through the proxy.
-   The container runs as root; files it writes are root-owned.

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: paisa
-   Compose file path: paisa/compose.yaml
-   Additional env file (optional): paisa/sample.env

Then "Load" paisa/sample.env into the Environment variables in dockhand.

Create the Stack

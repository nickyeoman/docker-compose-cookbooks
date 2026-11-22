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

1. Copy this stack's `config/` folder to `${VOL_PATH:-/data}/paisa`
   and make it a git repo. It holds `paisa.yaml`, an empty `main.ledger`,
   `sheets/`, and a `.gitignore`. Edit `paisa.yaml` to suit you.
   Or start from one of the `templates/` folders instead. Each has a chart
   of accounts, a budget, and commented example entries; fill in its `TODO`s:
   -   `personal/` — one person: salary, TFSA/RRSP, everyday spending
   -   `household/` — two adults and a child: joint accounts, mortgage,
       CCB, RESP, childcare
   -   `business/` — sole proprietor (not incorporated): GST/PST, owner
       draws, T2125 expense categories
   -   `corporation/` — small BC corporation: share capital, shareholder
       loan, payroll, WorkSafeBC
2. Deploy the stack. Paisa creates `paisa.db` in the same folder.
3. Open http://localhost:7500 in your browser.

To explore first, see [docs/demo.md](docs/demo.md) for the sample books of
Demolition Company Ltd. For ledger syntax, see
[docs/ledger-cheatsheet.md](docs/ledger-cheatsheet.md). Accountants new to
Paisa should read [docs/paisa-for-accountants.md](docs/paisa-for-accountants.md),
especially the section on closing entries.

## Environment Variable Notes

    PAISA_IMAGE – container image (default ananthakumaran/paisa:latest)
    PAISA_RESTART – restart policy (default unless-stopped)
    VOL_PATH – host base path; the ledger git repo is VOL_PATH/paisa (default /data)
    PAISA_PORT – host port for the web UI (default 7500)

## Volume Notes

One volume holds everything:

-   `/root/Documents/paisa` — `paisa.yaml`, `*.ledger`, `sheets/`, and
    `paisa.db`; `${VOL_PATH:-/data}/paisa` on the host

The compose file appends `/paisa` to `VOL_PATH`, so the folder is always
named `paisa`.
Keep the folder in git; the shipped `.gitignore` keeps `paisa.db` out of
commits. The database is a cache rebuilt from the ledger files.

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

-   If Paisa finds no `paisa.yaml`, it creates one with Indian defaults
    (INR, en-IN, fiscal year starting in April), so copy `config/` in first.
-   `paisa.db` sits in the git folder (`db_path: paisa.db`); keep the
    shipped `.gitignore` so it isn't committed.
-   `config/paisa.yaml` uses CAD, en-US number formatting,
    America/Vancouver, a January fiscal year, and no login. Add
    `user_accounts` before exposing Paisa through the proxy.
-   The container runs as root; files it writes are root-owned.
-   With `strict: "yes"`, Paisa's editor checks each file on its own
    (`ledger --pedantic` on just that file), so every `.ledger` file that
    posts to accounts starts with `include accounts.ledger`. Without it
    the editor shows `Unknown account` for every line, even though the
    full journal is fine. Add the include to any new year file.

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: paisa
-   Compose file path: paisa/compose.yaml
-   Additional env file (optional): paisa/sample.env

Then "Load" paisa/sample.env into the Environment variables in dockhand.

Create the Stack

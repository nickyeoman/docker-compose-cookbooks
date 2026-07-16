# DumbBudget

## Overview

Stupid-simple self-hosted budgeting app for tracking expenses and income, protected by a PIN.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/DumbWareio/DumbBudget)
-   **Container Image:** [dumbwareio/dumbbudget](https://hub.docker.com/r/dumbwareio/dumbbudget)
-   **Documentation:** [GitHub README](https://github.com/DumbWareio/DumbBudget/blob/main/README.md)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    DUMBBUDGET_PIN – access PIN (change it!)
    DUMBBUDGET_CURRENCY – ISO currency code

## Volume Notes

    /app/data – transactions and settings

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name dumbbudget \
  -p 3000:3000 \
  -e DUMBBUDGET_PIN=1234 -e BASE_URL=http://localhost:3000 -e CURRENCY=CAD \
  -v /data/dumbbudget/data:/app/data \
  dumbwareio/dumbbudget:latest
```

## Additional Notes / Gotchas

PIN auth only — keep behind the proxy and don't expose publicly.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: dumbbudget_dev
Compose file path: dumbbudget_dev/compose.yaml
Additional env file (optional): dumbbudget_dev/sample.env

Then "Load" dumbbudget_dev/sample.env into the Environmental variables in dockhand

Create the Stack

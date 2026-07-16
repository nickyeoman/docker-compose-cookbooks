# Mail Archiver

## Overview

Self-hosted email archiving, search, and export tool with multi-account folder sync.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/s1t5/mail-archiver)
-   **Container Image:** [s1t5/mailarchiver](https://hub.docker.com/r/s1t5/mailarchiver)
-   **Documentation:** [Setup docs](https://github.com/s1t5/mail-archiver/blob/main/doc/Setup.md)
-   **Reverse Proxy Port:** `5000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:5000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    MAILARCHIVER_USERNAME / MAILARCHIVER_PASSWORD – web UI admin login
    MAILARCHIVER_DB_PASSWORD – must match in both the app connection string and postgres

## Volume Notes

    /var/lib/postgresql/data – PostgreSQL data (the archive itself)

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name mailarchiver \
  -p 5000:5000 \
  -e 'ConnectionStrings__DefaultConnection=Host=dbhost;Database=MailArchiver;Username=mailuser;Password=pass' \
  -e Authentication__Username=admin -e Authentication__Password=pass \
  s1t5/mailarchiver:latest
```

## Additional Notes / Gotchas

No built-in HTTPS — keep behind the reverse proxy. Add mail accounts through the web UI after first login.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: mailarchiver_dev
Compose file path: mailarchiver_dev/compose.yaml
Additional env file (optional): mailarchiver_dev/sample.env

Then "Load" mailarchiver_dev/sample.env into the Environmental variables in dockhand

Create the Stack

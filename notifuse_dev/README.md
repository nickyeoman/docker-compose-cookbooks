# Notifuse

## Overview

Newsletter, marketing campaign, and transactional email platform (open-source Mailchimp/Resend alternative).

## Project Details

-   **Project Repository:** [GitHub](https://github.com/Notifuse/notifuse)
-   **Container Image:** [notifuse/notifuse](https://hub.docker.com/r/notifuse/notifuse)
-   **Documentation:** [docs.notifuse.com](https://docs.notifuse.com/self-hosting/installation)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    NOTIFUSE_SECRET_KEY – encrypts all workspace secrets; NEVER change after setup or all stored credentials are lost
    NOTIFUSE_ROOT_EMAIL – initial admin account
    NOTIFUSE_API_ENDPOINT – public URL of the instance

## Volume Notes

    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name notifuse \
  -p 8080:8080 \
  -e API_ENDPOINT=http://localhost:8080 \
  -e ROOT_EMAIL=admin@example.com \
  -e SECRET_KEY=changeme \
  -e DB_HOST=dbhost -e DB_USER=notifuse -e DB_PASSWORD=pass -e DB_NAME=notifuse \
  notifuse/notifuse:latest
```

## Additional Notes / Gotchas

Notifuse creates a separate Postgres database per workspace, so the DB user needs CREATEDB privileges (the postgres superuser in this stack has it).
Sending requires an email provider (SES, Mailgun, SendGrid, Postmark, or SMTP) configured in the setup wizard.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: notifuse_dev
Compose file path: notifuse_dev/compose.yaml
Additional env file (optional): notifuse_dev/sample.env

Then "Load" notifuse_dev/sample.env into the Environmental variables in dockhand

Create the Stack

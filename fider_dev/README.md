# Fider

## Overview

Feedback collection platform for product ideas, suggestions, and user voting.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/getfider/fider)
-   **Container Image:** [getfider/fider](https://hub.docker.com/r/getfider/fider)
-   **Documentation:** [fider.io](https://fider.io/docs)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    FIDER_JWT_SECRET – long random string, generate with `openssl rand -hex 32`
    FIDER_BASE_URL – public URL of the instance
    FIDER_SMTP_* – Fider requires working email to sign in (magic links)

## Volume Notes

    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name fider \
  -p 3000:3000 \
  -e BASE_URL=http://localhost:3000 \
  -e DATABASE_URL=postgres://fider:pass@dbhost:5432/fider?sslmode=disable \
  -e JWT_SECRET=changeme \
  -e EMAIL_NOREPLY=noreply@example.com \
  getfider/fider:stable
```

## Additional Notes / Gotchas

Email is not optional — sign-in uses magic links, so SMTP (or Mailgun env vars) must be configured before first use.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: fider_dev
Compose file path: fider_dev/compose.yaml
Additional env file (optional): fider_dev/sample.env

Then "Load" fider_dev/sample.env into the Environmental variables in dockhand

Create the Stack

# PostHog

## Overview

PostHog is a self-hosted product analytics platform offering event tracking, session recording, feature flags, and experimentation. This Docker Compose stack deploys PostHog with PostgreSQL, Redis, ClickHouse, and Kafka.

**Note:** PostHog is resource-intensive. Minimum 4GB RAM, 8GB+ recommended.

## Project Details

-   **Project Repository:** [PostHog](https://posthog.com)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/posthog/posthog)
-   **Compose Example:** [Official Hobby Compose](https://github.com/PostHog/posthog/blob/master/docker-compose.hobby.yml)
-   **Documentation:** [Self-Host Docs](https://posthog.com/docs/self-host)
-   **Reverse Proxy Port:** `8000`

## Getting Started

1. Copy `sample.env` to `.env` and edit all values (especially `POSTHOG_SECRET_KEY`)
2. Start the stack: `docker compose up -d` (first startup will run migrations — this can take several minutes)
3. Open http://localhost:8000 in your browser
4. Create your admin account on first visit

## Environment Variable Notes

### Compose
-   `VOL_PATH` – base path for persistent data (default: `/data`)
-   `POSTHOG_IMAGE` – image tag (default: `posthog/posthog:latest`)
-   `POSTHOG_RESTART` – restart policy (default: `unless-stopped`)

### Core
-   `POSTHOG_SITE_URL` – public URL of your PostHog instance (required)
-   `POSTHOG_SECRET_KEY` – Django secret key for session encryption (required, set to a long random string)

### Database
-   `POSTHOG_DB_NAME` – PostgreSQL database name (default: `posthog`)
-   `POSTHOG_DB_USER` – PostgreSQL user (default: `posthog`)
-   `POSTHOG_DB_PASSWORD` – PostgreSQL password (required)

### ClickHouse
-   `POSTHOG_CLICKHOUSE_DB` – ClickHouse database name (default: `posthog`)
-   `POSTHOG_CLICKHOUSE_USER` – ClickHouse user (default: `clickhouse`)
-   `POSTHOG_CLICKHOUSE_PASSWORD` – ClickHouse password (required)

### Email (optional)
-   `POSTHOG_EMAIL_HOST` – SMTP server host
-   `POSTHOG_EMAIL_USER` – SMTP username
-   `POSTHOG_EMAIL_PASSWORD` – SMTP password
-   `POSTHOG_EMAIL_PORT` – SMTP port (default: `587`)
-   `POSTHOG_EMAIL_TLS` – enable TLS (default: `true`)

## Volume Notes

-   `${VOL_PATH:-/data}/posthog/postgres` – PostgreSQL data
-   `${VOL_PATH:-/data}/posthog/redis` – Redis data
-   `${VOL_PATH:-/data}/posthog/clickhouse` – ClickHouse analytics data
-   `${VOL_PATH:-/data}/posthog/kafka` – Kafka message queue data
-   `${VOL_PATH:-/data}/posthog/data` – PostHog app data (uploads, exports)
-   `${VOL_PATH:-/data}/posthog/logs` – application logs

## Network Notes

-   Requires the external `proxy` network for reverse proxy access.
-   All backend services communicate over the internal network.

## Docker Run

PostHog requires multiple interdependent services. Use the Docker Compose stack rather than individual `docker run` commands.

## Additional Notes / Gotchas

-   **Resource heavy.** PostHog needs at least 4GB RAM and 10GB disk. ClickHouse and Kafka are memory-intensive.
-   **First startup is slow.** Migrations run on initial deploy and can take 5–10 minutes. Check logs with `docker compose logs -f posthog`.
-   **SECRET_KEY must be set.** Generate one with `openssl rand -hex 32` and set it in `.env`.
-   **Kafka** runs without authentication on the internal network only.
-   This is a simplified dev deployment. For production, see the [official hobby compose](https://github.com/PostHog/posthog/blob/master/docker-compose.hobby.yml) which includes additional services (plugins, ingestion pipelines, object storage, etc.).
-   Port 8000 is the internal web port. Proxy it through Nginx Proxy Manager on the `proxy` network.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: posthog
Compose file path: posthog_dev/compose.yaml
Additional env file (optional): posthog_dev/sample.env

Then "Load" posthog_dev/sample.env into the Environmental variables in dockhand

Create the Stack

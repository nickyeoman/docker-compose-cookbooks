# PeerTube

* [Docs](https://docs.joinpeertube.org/)

Proxy port: 1935

Change admin user (username is admin in gui but root in cli):

```
docker compose exec peertube npm run reset-password -- -u root
```

NOTICE: I've added this one for testing, it didn't fit what I was wanting, but I'll levae it here as it did boot.

## Overview

Federated, peer-to-peer video hosting platform.

## Project Details

-   **Container Image:** [chocobozzz/peertube:production-bookworm](https://hub.docker.com/r/chocobozzz/peertube)
-   **Reverse Proxy Port:** `9000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    PEERTUBE_HOSTNAME – default: localhost
    PEERTUBE_ADMIN_EMAIL – default: admin@example.com
    PEERTUBE_ADMIN_PASSWORD – default: ChangeThisPassword
    PEERTUBE_PORT – default: 9000

## Volume Notes

    /var/lib/postgresql/data – host path /data/peertube/postgres
    /data – host path /data/peertube/redis
    /data – host path /data/peertube/data
    /config – host path /data/peertube/config

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name peertube \
  -p 9000:9000 \
  -v /data/peertube/postgres:/var/lib/postgresql/data \
  -v /data/peertube/redis:/data \
  -v /data/peertube/data:/data \
  -v /data/peertube/config:/config \
  chocobozzz/peertube:production-bookworm
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: peertube_dev
Compose file path: peertube_dev/compose.yaml
Additional env file (optional): peertube_dev/sample.env

Then "Load" peertube_dev/sample.env into the Environmental variables in dockhand

Create the Stack

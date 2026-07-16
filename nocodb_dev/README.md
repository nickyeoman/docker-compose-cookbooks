# nocodb

Last Updated: Thu August 01, 2024 18:40:57 PDT

## Overview

Docker Hub: https://hub.docker.com/r/nocodb/nocodb
Project: https://nocodb.com/
Docker Compose Example: https://github.com/nocodb/nocodb/blob/master/docker-compose/mysql/docker-compose.yml
Proxy Port: 8080

## Project Details

-   **Container Image:** [nocodb/nocodb:latest](https://hub.docker.com/r/nocodb/nocodb)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    NOCODB_PORT – default: 8080

## Volume Notes

    /usr/app/data – host path /data/nocodb

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name nocodb \
  -p 8080:8080 \
  -v /data/nocodb:/usr/app/data \
  nocodb/nocodb:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: nocodb_dev
Compose file path: nocodb_dev/compose.yaml
Additional env file (optional): nocodb_dev/sample.env

Then "Load" nocodb_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Description

This project is setup to use sql lite.  Although it can use mysql with some env vars.

## Notes

# environment:
    #   - NC_DB=${NCDB_NC_DB:-mysql2://root_db:3306?u=noco&p=password&d=root_db}

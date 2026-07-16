# ITFlow

## Overview

IT documentation, ticketing, and asset management platform for MSPs.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/itflow-org/itflow)
-   **Container Image:** [itfloworg/itflow](https://hub.docker.com/r/itfloworg/itflow)
-   **Documentation:** [docs.itflow.org](https://docs.itflow.org/installation_docker)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    ITFLOW_DB_PASSWORD – database password used by the setup wizard

## Volume Notes

    /var/www/itflow/uploads – uploaded files
    /var/lib/mysql – MariaDB data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name itflow \
  -p 8080:80 \
  itfloworg/itflow:latest
```

## Additional Notes / Gotchas

The Docker image is community-maintained and explicitly not production-ready.
On first visit the setup wizard asks for the database host (`itflow-db`), user, and password.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: itflow_dev
Compose file path: itflow_dev/compose.yaml
Additional env file (optional): itflow_dev/sample.env

Then "Load" itflow_dev/sample.env into the Environmental variables in dockhand

Create the Stack

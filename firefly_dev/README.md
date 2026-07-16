# Firefly iii

## Overview

Docker Hub: https://hub.docker.com/r/fireflyiii/core/tags
Documentation: https://docs.firefly-iii.org/how-to/firefly-iii/installation/docker/
Project: https://firefly-iii.org/
Proxy Port: 8080
Proxy Port Importer: 8080

## Project Details

-   **Container Image:** [fireflyiii/core:latest](https://hub.docker.com/r/fireflyiii/core)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    FIREFLY_PORT – default: 8080

## Volume Notes

    /var/www/html/storage/upload – host path /data/firefly
    /var/www/html/storage/upload – host path /data/firefly

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name firefly \
  -p 8080:8080 \
  -v /data/firefly:/var/www/html/storage/upload \
  -v /data/firefly:/var/www/html/storage/upload \
  fireflyiii/core:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: firefly_dev
Compose file path: firefly_dev/compose.yaml
Additional env file (optional): firefly_dev/sample.env

Then "Load" firefly_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Notes

The Firefly III Data Importer will ask you for the Firefly III URL and a "Client ID".
You can generate the Client ID at http://localhost/profile (after registering)
The Firefly III URL is: http://app:8080
Other URL's will give 500 | Server Error

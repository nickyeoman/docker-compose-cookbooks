# Filebrowser Quantum

A lightweight Docker Compose setup for running the **Filebrowser Quantum** container.
The future of Filebrowser was in question so switched to Quantum.

## Overview

* [Filebrowser Quantum on GitHub](https://github.com/gtsteffaniak/filebrowser/tree/main)
* [Getting Started Wiki](https://github.com/gtsteffaniak/filebrowser/wiki/Getting-Started)
* [Configuration Docs](https://github.com/gtsteffaniak/filebrowser/wiki/Configuration-And-Examples)

## Project Details

-   **Container Image:** [gtstef/filebrowser:latest](https://hub.docker.com/r/gtstef/filebrowser)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    FILEBROWSER_CONFIG_PATH – default: /data/filebrowser
    FILEBROWSER_CONFIG – default: /home/filebrowser/config.yaml
    FILEBROWSER_ADMIN_PASSWORD – default: ChangeThisPassword
    FILEBROWSER_PORT – default: 8080

## Volume Notes

    /srv – host path /data/storage
    /home/filebrowser/data – host path /data/filebrowser/root
    /home/filebrowser/config.yaml – host path /data/filebrowser/config.yaml

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name filebrowser \
  -p 8080:80 \
  -v /data/storage:/srv \
  -v /data/filebrowser/root:/home/filebrowser/data \
  -v /data/filebrowser/config.yaml:/home/filebrowser/config.yaml \
  gtstef/filebrowser:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: filebrowser_dev
Compose file path: filebrowser_dev/compose.yaml
Additional env file (optional): filebrowser_dev/sample.env

Then "Load" filebrowser_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Quick Notes

Proxy Port: 80

Default user account:
* Username: admin
* Password: admin

# ArchiveBox

## Overview

ArchiveBox is a self-hosted app that lets you preserve content from websites in a variety of formats.

## Project Details

-   **Project Website:** [ARCHIVEBOX](https://archivebox.io/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/archivebox/archivebox/tags)
-   **Compose Example:** [Compose](https://raw.githubusercontent.com/ArchiveBox/ArchiveBox/dev/docker-compose.yml)
-   **Documentation:** [Docs](https://github.com/ArchiveBox/ArchiveBox/wiki)
-   **Reverse Proxy Port:** `8000`

## Environment Variable Notes

    ARCHIVEBOX_IMAGE - you can lock the version like so: ```archivebox/archivebox:sha-1d49bee```
    ARCHIVEBOX_UID - User 1000
    ARCHIVEBOX_GID - Group 1000
    PYTHONUNBUFFERED - Ensures logs are output in real-time

## Volume Notes

    /data – just one volume

## Network Notes

Requires proxy network

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: archivebox
Compose file path: archivebox/compose.yaml
Additional env file (optional): archivebox/sample.env

Then "Load" archivebox/sample.env into the Environmental variables in dockhand

Create the Stack

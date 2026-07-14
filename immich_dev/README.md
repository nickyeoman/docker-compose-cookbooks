# Immich

## Overview

Self-hosted photo and video management solution with a mobile app,
machine-learning powered search, and face recognition. This stack runs the
Immich server, a machine-learning service, Redis, and a pgvecto.rs
(Postgres) database.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/immich-app/immich)
-   **Container Image:** [ghcr.io](https://github.com/immich-app/immich/pkgs/container/immich-server)
-   **Compose Example:** [Docs](https://immich.app/docs/install/docker-compose/)
-   **Documentation:** [Docs](https://immich.app/docs)
-   **Reverse Proxy Port:** `2283`

## Getting Started

1. Start the containers: `docker compose up -d`
2. Open http://localhost:8000 in your browser
3. Follow the initial setup wizard to create the admin account

## Environment Variable Notes

See the [environment variable documentation](https://immich.app/docs/install/environment-variables).

    IMMICH_IMAGE – immich server image/tag
    IMMICH_ML_IMAGE – machine-learning service image/tag (add -cuda, -openvino, or -armnn for hardware acceleration)
    IMMICH_PORT – host port mapped to the server's internal port 2283
    IMMICH_DB_PASSWORD / IMMICH_DB_USERNAME / IMMICH_DB_DATABASE_NAME – Postgres credentials, shared between the server and the database

## Volume Notes

    ${VOL_PATH}/immich/upload – uploaded photo/video library
    ${VOL_PATH}/immich/import – drop files here for external library import
    ${VOL_PATH}/immich/model-cache – downloaded machine-learning models
    ${VOL_PATH}/immich/postgres – database data

## Network Notes

Requires proxy network. Redis, Postgres, and the machine-learning service
only join the internal network.

## Docker Run

Not practical for this stack — Immich needs the server, machine-learning,
Redis, and Postgres containers together. Use the compose file.

## Additional Notes / Gotchas

### Import

1. Go to the Administrator and [External Libraries](http://localhost:8000/admin/library-management)
1. Choose the path: ```/import```
1. Place your files in the import directory.
1. Run the [Job](http://localhost:8000/admin/jobs-status) External Libraries

### Upgrades

The version tags can be confusing here.
I go to the releases page: https://github.com/immich-app/immich/releases
and then bump to that release: IMMICH_IMAGE=ghcr.io/immich-app/immich-server:v1.143.1

### Env changes not applying

If the env file doesn't work after a change, try running ```docker compose up -d --force-recreate```.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: immich
Compose file path: immich_dev/compose.yaml
Additional env file (optional): immich_dev/sample.env

Then "Load" immich_dev/sample.env into the Environmental variables in dockhand

Create the Stack

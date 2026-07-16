# Redis

## Overview

Redis is an open-source in-memory data structure store used as a database, cache, and message broker. It's highly popular for its performance and versatility.

## Project Details

-   **Project Repository:** https://github.com/redis/redis
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/redis)
-   **Compose Example:** [Redis Docker Compose](https://github.com/redis/redis/tree/7.0/utils#docker)
-   **Documentation:** [Redis Docs](https://redis.io/docs/)
-   **Reverse Proxy Port:** `6379`

## Getting Started

1. Start the container: `docker compose up -d`
2. Connect to Redis using: `redis-cli -h localhost -p 6379`

## Environment Variable Notes

-   `REDIS_IMAGE` – Redis Docker image to use (default: `redis:alpine`)
-   `REDIS_PORT` – Redis port to expose (default: `6379`)
-   `TZ` – Timezone for container (default: `UTC`)

## Volume Notes

-   `/data` – Persistent Redis data directory ( stores Redis data on disk via save configuration)

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name redis \
  -e REDIS_IMAGE=redis:alpine \
  -e REDIS_PORT=6379 \
  -e TZ=UTC \
  -v ${VOL_PATH:-/data}/redis:/data \
  -p 6379:6379 \
  redis:alpine
```

## Additional Notes / Gotchas

-   Make sure to configure persistence in your Redis setup using the `save` configuration
-   Use `docker compose exec redis redis-cli` to access the running container
-   Remember to set a strong `redis-cli` password if using Redis in production

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: redis
Compose file path: redis_dev/compose.yaml
Additional env file (optional): redis_dev/sample.env

Then "Load" redis_dev/sample.env into the Environmental variables in dockhand

Create the Stack

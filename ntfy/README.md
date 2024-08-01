# ntfy

Last Updated: Wed July 31, 2024 20:41:59 PDT

## Overview

* [Docker Hub](https://hub.docker.com/r/binwiederhier/ntfy)
* [Project](https://ntfy.sh/)
* [Docker Compose Example](https://github.com/binwiederhier/ntfy/blob/main/docker-compose.yml)

Proxy Port: 80

## Healthcheck

You can add a healthcheck to docker compose like so:

```yaml
healthcheck: # optional: remember to adapt the host:port to your environment
      test: ["CMD-SHELL", "wget -q --tries=1 https://yourdomain.com/v1/health -O - | grep -Eo '\"healthy\"\\s*:\\s*true' || exit 1"]
      interval: 60s
      timeout: 10s
      retries: 3
      start_period: 40s
```

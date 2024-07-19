# Watchtower

**WORK IN PROGRESS**

url: https://containrrr.dev/watchtower/
dockerhub: https://hub.docker.com/r/containrrr/watchtower/tags

Must be run as root, caution it has access to all your containers, not per domain/project.

## Project Setup

```yaml
version: '3.4'

services:

  watchtower:
    extends:
      file: ${COOKBOOK}/watchtower/docker-compose.yml
      service: watchtower
    env_file:
      - .env
```

### env setup

```text
# Local
COOKBOOK=/home/user/git/docker-compose-cookbooks
WATCHTOWER_IMAGE=containrrr/watchtower:1.7.1

# Container Optional
REPO_USER=username
REPO_PASS=password
```

## Container selection


```yaml
labels:
      - "com.centurylinklabs.watchtower.enable=true"
```

Monitor Only
```yaml
labels:
      - com.centurylinklabs.watchtower.monitor-only="true"
```


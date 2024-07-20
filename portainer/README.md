# Portainer

## Ports

Portainer: 9000
Portainer Agent: 9001

## Network

Create a private network for portainer: ```sudo podman network create portainer-net```

## env config

You must set an agent secret ```openssl rand -base64 32```

```
PORTAINER_IMAGE=portainer/portainer-ce:latest
PORTAINER_AGENT_IMAGE=portainer/agent:latest
AGENT_SECRET=01234567890132456789012345678912
VOL_PATH=/docker/vol/portainer-data
COOKBOOK=/home/user/git/docker-compose-cookbooks
```

### Docker Compose Extend

Now using extend you can call the service:

```yaml
version: '3.4'

networks:
  portainer-net:
    external: true

services:
    portainer-agent:
        extends:
            file: ${COOKBOOK}/portainer/docker-compose.yml
            service: portainer-agent
        env_file:
            - .env
    
    portainer:
        extends:
            file: ${COOKBOOK}/portainer/docker-compose.yml
            service: portainer
        env_file:
            - .env
```

You will likely want to spit up the agent and GUI in your projects.

## Gotchas

### Podman

Make sure podman-docker is installed.
# Semaphore

## Overview

* [Docker Hub](https://hub.docker.com/r/semaphoreui/semaphore)
* [Official Website](https://semaphoreui.com/)
* [Docker Compose Example](https://docs.semaphoreui.com/administration-guide/installation/#docker)

## Reverse Proxy

Proxy Port: 3000

## Notes

Setting up ssh keys is a pain, a volume is setup to include your credentials.
make sure the permissions are set to user 1001. 

### SEMAPHORE_ACCESS_KEY_ENCRYPTION

must generate this way: head -c32 /dev/urandom | base64

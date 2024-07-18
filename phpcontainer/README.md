# 4 Light's Php Container

Proxy Port: 80

## Preperation

You should copy over the php.ini.

In your data directory there should be a public folder for apache.

## Docker Compose Extend

Now using extend you can call the service:

```yaml
version: '3.4'

services:
  stash:
    extends:
      file: ${COOKBOOK}/phpcontainer/docker-compose.yml
      service: php-apache
    env_file:
      - .env
```
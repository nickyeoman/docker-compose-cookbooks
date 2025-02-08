# 4 Light's Php Container

Proxy Port: 80

## Preperation

You should copy over the php.ini.

In your data directory there should be a public folder for apache.


## env file

PHPCONTAINER_IMAGE=4lights/phpcontainer:latest
VOL_PATH=/project_dir/project/data

## Docker Compose Extend

Now using extend you can call the service:

```yaml
services:

  php-apache:
    extends:
      file: ${COOKBOOK}/phpcontainer/docker-compose.yml
      service: php-apache
    volumes:
      - "./project:/data"
      - "./config/php.ini:/usr/local/etc/php/php.ini"
      
```
# Invoice Ninja

Proxy port 80 to nginx.

You have to build this one
```
docker buildx build --no-cache -f Dockerfile -t invoiceninja .
```

This repo is just a slight modification of [the source](https://github.com/invoiceninja/dockerfiles/) you should go there for support.


I'm not a big fan of all the licensing and paywall features.

## Overview

Invoicing, payments, and client management for freelancers and small businesses.

## Project Details

-   **Container Image:** [nginx:alpine](https://hub.docker.com/_/nginx)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    DB_DATABASE – default: ninja
    DB_USERNAME – default: ninja
    DB_PASSWORD – default: ChangeThisPassword
    DB_ROOT_PASSWORD – default: ChangeThisPassword
    APP_URL – default: http://localhost:8000
    APP_KEY – default: ChangeThisPassword
    APP_ENV – default: production
    APP_DEBUG – default: false
    REQUIRE_HTTPS – default: false
    PHANTOMJS_PDF_GENERATION – default: false
    PDF_GENERATOR – default: snappdf
    TRUSTED_PROXIES – default: *
    CACHE_DRIVER – default: redis
    QUEUE_CONNECTION – default: redis
    (see sample.env for the full list)

## Volume Notes

    /var/lib/mysql – host path /data/invoiceninja/mysql
    /var/www/html/public – host path /data/invoiceninja/public
    /var/www/html/storage – host path /data/invoiceninja/storage
    /etc/nginx/conf.d – host path /data/invoiceninja/nginx
    /var/www/html/public – host path /data/invoiceninja/public
    /var/www/html/storage – host path /data/invoiceninja/storage

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name invoiceninja \
  -p 8000:80 \
  -v /data/invoiceninja/mysql:/var/lib/mysql \
  -v /data/invoiceninja/public:/var/www/html/public \
  -v /data/invoiceninja/storage:/var/www/html/storage \
  -v /data/invoiceninja/nginx:/etc/nginx/conf.d:ro \
  -v /data/invoiceninja/public:/var/www/html/public:ro \
  nginx:alpine
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: invoiceninja_dev
Compose file path: invoiceninja_dev/compose.yaml
Additional env file (optional): invoiceninja_dev/sample.env

Then "Load" invoiceninja_dev/sample.env into the Environmental variables in dockhand

Create the Stack

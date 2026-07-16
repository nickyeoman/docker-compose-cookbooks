# Authentik

Here is the official doc: https://docs.goauthentik.io/install-config/install/docker-compose/

Authentik is on a 2 month release cycle and should be updated in order of release.

## Overview

Identity provider and SSO platform supporting OIDC, SAML, LDAP, and proxy authentication.

## Project Details

-   **Container Image:** [ghcr.io/goauthentik/server:2025.10.1](https://github.com/goauthentik/server)
-   **Reverse Proxy Port:** `9000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    PG_DB – default: authentik
    PG_USER – default: authentik
    AUTHENTIK_TAG – default: 2025.10.1
    PG_PASS – default: (none, must be set)
    AUTHENTIK_PORT_HTTP – default: 9000
    AUTHENTIK_PORT_HTTPS – default: 9443

## Volume Notes

    /var/lib/postgresql/data – host path /data/authentik/db
    /media – host path /data/authentik/media
    /templates – host path /data/authentik/custom-templates
    /media – host path /data/authentik/media
    /certs – host path /data/authentik/certs
    /templates – host path /data/authentik/custom-templates

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name authentik \
  -p 9000:9000 \
  -p 9443:9443 \
  -v /data/authentik/db:/var/lib/postgresql/data \
  -v /data/authentik/media:/media \
  -v /data/authentik/custom-templates:/templates \
  -v /data/authentik/media:/media \
  -v /data/authentik/certs:/certs \
  ghcr.io/goauthentik/server:2025.10.1
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: authentik_dev
Compose file path: authentik_dev/compose.yaml
Additional env file (optional): authentik_dev/sample.env

Then "Load" authentik_dev/sample.env into the Environmental variables in dockhand

Create the Stack

# Gatus

## Overview

Track uptime.

## Project Details

-   **Project Repository:** [Link](https://github.com/TwiN/gatus)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/twinproduction/gatus)
-   **Documentation:** [Docs](https://gatus.io/)
-   **Reverse Proxy Port:** `8080`

## Volume Notes

There are two mounts
CONFIG_FILE - Where the yaml config file lives.  Likely stored to a repo somewhere.
VOL_DATA - Which is the persistant data.

Note the db must be set in the config file for persistant to happen.

There is an example config.yaml file in this repo.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: Gatus
Compose file path: gatus/compose.yaml
Additional env file (optional): gatus/sample.env

Then "Load" gatus/sample.env into the Environmental variables in dockhand, then modify.

Create the Stack

## Docker Run

This one would be pretty easy to run on its own:

```
docker run -d \
  -e TZ=America/Vancouver \
  -p 8080:8080 \
  -v /data/config.yml:/config/config.yaml \
  -v /data/gatus:/config/data \
  twinproduction/gatus:latest
```
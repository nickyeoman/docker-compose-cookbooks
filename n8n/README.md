# n8n

It means "nodemation" and it is pronounced as n-eight-n.
Free and open fair-code licensed node based Workflow Automation Tool.

Last Updated: Wed December 04, 2024 06:31:09 PDT

## Overview

Docker Hub Docs: https://hub.docker.com/r/n8nio/n8n#start-n8n-in-docker
Official docs docker-compose: https://docs.n8n.io/hosting/installation/server-setups/docker-compose/#5-create-docker-compose-file
Docker Hub Tags: https://hub.docker.com/r/n8nio/n8n/tags
Proxy Port: 5678


## Notes

There is a license key required, which is free at the time of writing.

### Setup

You need to setup the data directory

```
mkdir -p data/n8n/
chown -R 1000:1000 data/
```

When you load the page for the first time it will ask for an admin account.

# Gitea

## Overview

Self Hosted Git repository.

## Project Details

-   **Project Repository:** [Link](https://about.gitea.com/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/gitea/gitea)
-   **Compose Example:** [Compose](https://docs.gitea.com/installation/install-with-docker)
-   **Reverse Proxy Port:** `3000`

## Environment Variable Notes

    ENABLE_SWAGGER="true" – Lets you: Test API calls in browser, See endpoints, Debug integrations
    MAX_RESPONSE_ITEMS="15" – controls pagination limits for API responses
    ROOT_URL - This is what Gitea uses for: Clone URLs, Redirects, Webhooks, OAuth callbacks
    LOCAL_ROOT_URL - You can't change the port from 3000, so you don't need this with this configuration.

## Volume Notes

volumes are easy, one for gitea and one for mariadb.

## Network Notes

We connect to the proxy network and have an internal network for db.

## Additional Notes / Gotchas


### 1000 User

We use the 1000 user without option to change.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: gitea
Compose file path: gitea/compose.yaml
Additional env file (optional): gitea/sample.env

Then "Load" gitea/sample.env into the Environmental variables in dockhand, providing your variables.

Create the Stack

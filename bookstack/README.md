# Bookstack

## Overview

BookStack is a self-hosted wiki platform for organizing and storing documentation in a simple, book/chapter/page structure. This Docker Compose stack allows easy deployment with persistent storage.

## Project Details

-   **Project Repository:** [Bookstack Official](https://www.bookstackapp.com/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/solidnerd/bookstack)
-   **Compose Example:** [Compose](https://github.com/solidnerd/docker-bookstack/blob/master/docker-compose.yml)
-   **Documentation:** [Docs](https://www.bookstackapp.com/docs/)
-   **Reverse Proxy Port:** `8080`

## Notes

### APP_KEY

Generate an APP_KEY: echo -n "base64:"$(openssl rand -base64 32)

### Default Password

* Username/Email: admin@admin.com
* Password: password

After logging in, go to Settings > My Account to update the password (and email if desired). This prevents unauthorized access.

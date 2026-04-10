# Thunderbird

## Overview

Access the application's full graphical interface directly from any modern web browser - no downloads, installs, or setup required on the client side - or connect with any VNC client.

The web interface also offers audio playback, seamless clipboard sharing, an integrated file manager and terminal for accessing the container's files and shell, desktop notifications, and more.

## Project Details

-   **Project Repository:** [Link](https://github.com/jlesage/docker-thunderbird)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/jlesage/thunderbird)
-   **Reverse Proxy Port:** `5800`

## Environment Variable Notes

THUNDERBIRD_IMAGE=jlesage/thunderbird:latest

Used for securing online:
```
THUNDERBIRD_WEB_AUTHENTICATION=1
THUNDERBIRD_WEB_AUTHENTICATION_USERNAME=user
THUNDERBIRD_WEB_AUTHENTICATION_PASSWORD=password
THUNDERBIRD_SECURE_CONNECTION=1
```

## Volume Notes

I use the import/export plugin for thunderbird so I've added an optional volume:
```thunderbird-export:/export```

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: NAME_HERE
Compose file path: SERVICENAME/compose.yaml
Additional env file (optional): SERVICENAME/sample.env

Then "Load" SERVICENAME/sample.env into the Environmental variables in dockhand

Create the Stack
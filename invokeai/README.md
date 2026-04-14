# Project Name

## Overview

A short 1--3 sentence description of what this Docker Compose project
does.

## Project Details

-   **Project Repository:** [Link](https://example.com)
-   **Container Image:** [Docker Hub](https://dockerhub.com)
-   **Compose Example:** [Compose](https://dockerhub.com)
-   **Documentation:** [Docs](https://dockerhub.com)
-   **Reverse Proxy Port:** `80`

## Environment Variable Notes

List any required or optional environment variables, where they come
from, and how they are used.

Example:

    VAR_NAME – explanation of purpose
    ANOTHER_VAR – where to get the value

## Volume Notes

Describe important volumes, what they store, and whether they need
manual creation or backups.

Example:

    /data – persistent application storage
    /config – configuration files

## Network Notes

Requires proxy network

## Additional Notes / Gotchas

Add any special information someone should know before running the
project---quirks, caveats, network requirements, etc.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: invokeai
Compose file path: invokeai/compose.yaml
Additional env file (optional): invokeai/sample.env

Then "Load" SERVICENAME/sample.env into the Environmental variables in dockhand

Create the Stack
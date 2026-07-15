# Rocket.Chat

## Overview

Rocket.Chat is an open-source team messaging platform. This stack includes Rocket.Chat, MongoDB with replica set initialization, and an optional Hubot chatbot.

## Project Details

-   **Project Repository:** [https://github.com/RocketChat/Rocket.Chat](https://github.com/RocketChat/Rocket.Chat)
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/rocket-chat)
-   **Documentation:** [https://docs.rocket.chat](https://docs.rocket.chat)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the stack: `docker compose up -d`
2. Open https://${ROCKETCHAT_DOMAIN} in your browser
3. Follow the setup wizard to configure your Rocket.Chat instance

## Environment Variable Notes

    VOL_PATH – base path for persistent data volumes
    VOL_PROJECTS – base path for project directories
    ROCKETCHAT_IMAGE – Rocket.Chat container image (default: rocketchat/rocket.chat:latest)
    ROCKETCHAT_RESTART – restart policy (default: unless-stopped)
    ROCKETCHAT_DOMAIN – domain name for reverse proxy access
    ROCKETCHAT_PORT – host port mapped to container port 3000 (default: 3000)
    MONGO_IMAGE – MongoDB container image (default: mongo:4.0)
    HUBOT_IMAGE – Hubot chatbot image (default: rocketchat/hubot-rocketchat:latest)

## Volume Notes

    ${VOL_PATH}/rocketchat_dev/uploads – Rocket.Chat file uploads
    ${VOL_PATH}/rocketchat_dev/db – MongoDB data directory
    ${VOL_PATH}/rocketchat_dev/dump – MongoDB dump directory
    ${VOL_PATH}/rocketchat_dev/hubot-scripts – Hubot custom scripts

## Network Notes

Requires the external `proxy` network. An internal bridge network `internal` is created for inter-service communication.

## Docker Run

```bash
docker run -d \
  --name rocketchat \
  -v ${VOL_PATH:-/data}/rocketchat_dev/uploads:/app/uploads \
  -e PORT=3000 \
  -e ROOT_URL=http://chat.example.com:3000 \
  -e MONGO_URL=mongodb://mongo:27017/rocketchat \
  -e MONGO_OPLOG_URL=mongodb://mongo:27017/local \
  -p 3000:3000 \
  --network proxy \
  rocketchat/rocket.chat:latest
```

## Additional Notes / Gotchas

- MongoDB uses the `mmapv1` storage engine with `--smallfiles` and `--oplogSize 128` for compatibility with Rocket.Chat.
- The `mongo-init-replica` service initializes the MongoDB replica set and exits. It must complete before Rocket.Chat starts.
- Hubot requires a bot user to be created in Rocket.Chat before it can connect. Update the password in the compose file or environment.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: ROCKETCHAT_DEV
Compose file path: rocketchat_dev/compose.yaml
Additional env file (optional): rocketchat_dev/sample.env

Then "Load" rocketchat_dev/sample.env into the Environmental variables in dockhand

Create the Stack

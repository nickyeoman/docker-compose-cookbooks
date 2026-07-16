# Invokeai

## Overview

Makes images, needs gpu.

## Project Details

-   **Project Repository:** [Github](https://github.com/invoke-ai/InvokeAI/tree/main)
-   **Container Image:** ghcr.io/invoke-ai/invokeai
-   **Documentation:** [Docs](https://invoke-ai.github.io/InvokeAI/)
-   **Reverse Proxy Port:** You Can set this in env, I have it set to 9090

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9090 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    INVOKEAI_PORT – default: 9090

## Volume Notes

    /invokeai – host path /data/invokeai

## Network Notes

Requires proxy network

## Docker Run

```
docker run -d \
  --name invokeai \
  --restart unless-stopped \
  -v "/data/invokeai:/invokeai" \
  -e INVOKEAI_ROOT=/invokeai \
  -e INVOKEAI_PORT=9090 \
  -p 9090:9090 \
  --gpus all \
  ghcr.io/invoke-ai/invokeai:latest
  ```

## Additional Notes / Gotchas

To get started, go to the models tab and install: RealVisXL V3 or Juggernaut XL
Also in the model manager, for upscale install: RealESRGAN_x4plus
And last install Tile SDXL version

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: invokeai
Compose file path: invokeai/compose.yaml
Additional env file (optional): invokeai/sample.env

Then "Load" invokeai/sample.env into the Environmental variables in dockhand

Create the Stack

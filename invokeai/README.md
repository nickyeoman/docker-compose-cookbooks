# Invokeai

## Overview

Makes images, needs gpu.

## Project Details

-   **Project Repository:** [Github](https://github.com/invoke-ai/InvokeAI/tree/main)
-   **Container Image:** ghcr.io/invoke-ai/invokeai
-   **Documentation:** [Docs](https://invoke-ai.github.io/InvokeAI/)
-   **Reverse Proxy Port:** You Can set this in env, I have it set to 9090

## Additional Notes / Gotchas

To get started, go to the models tab and install: RealVisXL V3 or Juggernaut XL
Also in the model manager, for upscale install: RealESRGAN_x4plus
And last install Tile SDXL version 

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: invokeai
Compose file path: invokeai/compose.yaml
Additional env file (optional): invokeai/sample.env

Then "Load" SERVICENAME/sample.env into the Environmental variables in dockhand

Create the Stack
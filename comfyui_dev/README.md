# ComfyUI

## Overview

Node-based interface for AI image generation workflows.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/comfyanonymous/ComfyUI)
-   **Container Image:** [yanwk/comfyui-boot](https://hub.docker.com/r/yanwk/comfyui-boot)
-   **Documentation:** [comfy.org](https://docs.comfy.org/)
-   **Reverse Proxy Port:** `8188`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8188 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    COMFYUI_IMAGE – pick the tag matching your CUDA version (cu124-slim, cu121, etc.)

## Volume Notes

    /root – models, custom nodes, outputs, and settings

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v /data/comfyui:/root \
  yanwk/comfyui-boot:cu124-slim
```

## Additional Notes / Gotchas

ComfyUI has no official image; yanwk/comfyui-boot is the most maintained community image.
GPU access is required for practical use — install the NVIDIA Container Toolkit and add a `gpus` / deploy reservation to the compose file (not included here since it depends on host setup).
Models are large; expect 20+ GB in the /root volume.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: comfyui_dev
Compose file path: comfyui_dev/compose.yaml
Additional env file (optional): comfyui_dev/sample.env

Then "Load" comfyui_dev/sample.env into the Environmental variables in dockhand

Create the Stack

# Ollama

Dockerhub: https://hub.docker.com/r/ollama/ollama
Github (instructions): https://github.com/open-webui/open-webui
Reverse Proxy Port webui: 8080 (The docker-compose sets the port to 3000)

## Preperation

You need to have nvidia-drivers, cuda and nvidia-container-toolkit
installed before proceeding.

docker run for refrence:
```
docker run -d --runtime=nvidia --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

podman exec -it ollama ollama pull llama3
podman exec -it ollama ollama run llama3
```

# Notes

this worked:
```bash
docker run -d -p 3000:8080 --gpus all --add-host=host.docker.internal:host-gateway -v webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
```

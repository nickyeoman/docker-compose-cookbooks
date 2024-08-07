# Ollama

Dockerhub: https://hub.docker.com/r/ollama/ollama

## Preperation

You need to have nvidia-drivers, cuda and nvidia-container-toolkit
installed before proceeding.

docker run for refrence:
```
docker run -d --runtime=nvidia --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

podman exec -it ollama ollama pull llama3
podman exec -it ollama ollama run llama3
```
# Ollama

**WORK IN PROGRESS**

Dockerhub: https://hub.docker.com/r/ollama/ollama

## Preperation

```
sudo yum install -y nvidia-container-toolkit
```

docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
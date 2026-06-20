# Ollama with Webui

![Ollama](https://i.4lt.ca/git/ollama.png)

There is a cpu version and a gpu version.
For ollama I'm just running latest, no version lock.
Same with standard ports, no option to change.

Dockerhub: https://hub.docker.com/r/ollama/ollama
Github (instructions): https://github.com/open-webui/open-webui
Reverse Proxy Port webui: 8080 (The docker-compose sets the port to 3000)

## Preperation

You need to have nvidia-drivers, cuda and nvidia-container-toolkit installed before proceeding.

docker run for refrence:
```
docker run -d --runtime=nvidia --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

docker exec -it ollama ollama pull llama3
docker exec -it ollama ollama run llama3
```
## Environment

WEBUI_SECRET_KEY is just a random secret string used to secure sessions, cookies, and auth in your WebUI.  ```openssl rand -hex 32```

You could also set OLLAMA_KEEP_ALIVE=5m if you are running multiple models. 5m is default, 0 removes as soon as done (then would have to reload model, so not quick), more than 5m is longer (minutes).
See "Docker Container Cheatsheet" below for how to remove models from memory.

## Use 

- [Ollama Models](https://ollama.com/search)

When using the webui for the first time after an upgrade, you will need to wait a long time. This is due to the model pulling process.

### Docker Container Cheatsheet

You can alias:
```bash
alias ollamac="docker compose exec -it ollama ollama"

#example then would be
ollamac list
```

Standard commands

```bash
# Enter a shell
docker exec -it ollama-ollama-1 sh

# Add/Pull a  model
ollama pull llama3.1:8b

# list models
ollama list

# Remove a model
ollama rm <model-name>

# Run CLI
ollama run <model-name> "What is Star Trek?"

# See what's running
ollama ps

# Clear memory
ollama stop <model-name>

```

### API

```bash
curl http://ollama.lan:11434/api/tags
```

# Notes

Straight docker run:
```bash
docker run -d -p 3000:8080 --gpus all --add-host=host.docker.internal:host-gateway -v webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
```
## Recommended Pulls

For a NVIDIA GeForce RTX 5060 Ti, your GPU may vary.

```
Generating prompts for InvokeAI
ollama pull llama3.1:8b
ollama pull mistral:7b-instruct
ollama pull mythomax-l2:13b

Generating PHP code
ollama pull codellama:13b-code
ollama pull deepseek-coder:6.7b-instruct
ollama pull wizardcoder:15b

Help with writing a book
ollama pull llama3.1:70b-instruct
ollama pull mythomax-l2:13b
ollama pull openhermes2.5-mistral:7b

Help with psychology questions/learning
ollama pull samantha-mistral:7b
ollama pull openchat:7b
ollama pull nous-hermes2-mixtral:8x7b-dpo

n8n agents
ollama pull qwen2.5-coder:7b-instruct
ollama pull llama3.1:8b-instruct
ollama pull gorilla-openfunctions-v2:7b

Summarizing documents
ollama pull granite3.2:8b-instruct
ollama pull cognitivetech/obook_summary:7b
ollama pull bge-m3:8b
```
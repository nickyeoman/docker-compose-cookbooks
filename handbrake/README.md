# Handbrake
 
DockerHub: https://hub.docker.com/r/jlesage/handbrake
Env docs: https://github.com/jlesage/docker-handbrake

## NOTES

You can specify read and write for example:
"handbrake-storage:/storage:ro"
"handbrake-output:/output:rw"

## Nvidia GPU

HANDBRAKE_IMAGE=zocker160/handbrake-nvenc:latest
Github: https://github.com/zocker-160/handbrake-nvenc-docker
DockerHub NVENC: https://hub.docker.com/r/zocker160/handbrake-nvenc
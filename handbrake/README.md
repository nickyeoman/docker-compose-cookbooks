# Handbrake
 
DockerHub: https://hub.docker.com/r/jlesage/handbrake
Env docs: https://github.com/jlesage/docker-handbrake

## SAMPLE ENV

```text
# Handbrake
VOL_PATH=/docker/vol/handbrake-data #HELP: volpath
VOL_CONFIG_PATH=/docker/vol #HELP: configpath
COOKBOOK=/home/user/git/docker-compose-cookbooks #HELP: cookbooks
HANDBRAKE_IMAGE=jlesage/handbrake:latest
```

## NOTES

You can specify read and write for example:
"handbrake-storage:/storage:ro"
"handbrake-output:/output:rw"

## Nvidia

HANDBRAKE_IMAGE=zocker160/handbrake-nvenc:latest
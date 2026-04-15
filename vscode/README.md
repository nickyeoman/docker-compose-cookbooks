# Code Server

## Overview

VS Code

## Project Details

-   **Project Website:** [Link](https://code.visualstudio.com/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/linuxserver/code-server)
-   **Reverse Proxy Port:** `8443`

## Environment Variable Notes

Data directory:
```
- ${VOL_PATH:-./data}/vscode/data:/data
```
This is where all your code is stored, it should be set to your 1000 user.  Then you can move your code here as that user.

## Additional Notes / Gotchas

For setup you need to set the user and group ID
you can do that by using ```id username```
or by changing the vol with ```chown -R user:group path/```

### Set git info

Open terminal and run:
```
git config --global user.name "Name"
git config --global user.email "your-email@example.com"
```

You also want to generate a key for your connection:
```
ssh-keygen -t ed25519 -C "c@nickyeoman.com"
cat ~/.ssh/id_ed25519.pub 
```

## Nginx Proxy manager

If you are placing this behind NPM then you need to enable web sockets.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: vscode
Compose file path: vscode/compose.yaml
Additional env file (optional): vscode/sample.env

Then "Load" vscode/sample.env into the Environmental variables in dockhand

Create the Stack
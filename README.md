<div align="center">
  <img src="https://i.4lt.ca/nickyeoman/dccb.png" alt="Nick Yeoman's Docker Compose Cookbook" width="800"/>
</div>

👤 Author: [Nick Yeoman](https://www.nickyeoman.com/).

Docker Compose file collection reference with the intent of running in production.

## Requirements and Support

I'm only one guy, I tested with

| Software            | Version   |
|---------------------|-----------|
| Debian              | 13        |
| Docker Engine       | 29.6.0    |
| Dockhand            | 1.0.32    |

## 🤔 Assumptions

These compose files make a few assumptions:

1. You are running dockhand.
2. You are using Nginx Proxy Manager (although most have redundant port access).

## 📚 Workflow

The intended workflow is as follows:

1. Add the repository ```https://github.com/nickyeoman/docker-compose-cookbooks.git``` to your dockhand Git repositories (in settings)
1. Create the stack in dockhand

## 🛠 Project Directory Structure

Directories ending with _dev contain projects that are still under development or experimental. These are not yet considered production ready.

Directories ending with _notes contain projects that usually don’t require a full Docker Compose file. They may include notes, example commands, or minimal Compose files just to illustrate setup. For example, the handbrake project has a compose-cpu.yaml and a compose-gpu.yaml.

## Test a Stack

To test a stack, clone the repository, navigate to the directory you're interested in, and run it:

```
git pull https://github.com/nickyeoman/docker-compose-cookbooks.git ~/cookbooks
cd ~/cookbooks
mkdir /data
touch /data/test.env
docker compose --env-file sample.env --env-file /data/test.env up -d
docker compose --env-file sample.env --env-file /data/test.env down
```

Multiple --env-file flags are supported and applied in order.

## Prefered Containers

These are projects that are not supported in this repo and the alternative:

1. [Dockge](https://dockge.kuma.pet/) - Simple Docker Compose stack manager with a clean UI for deploying and managing containers.
   *Preferred alternative: Dockhand - lighter-weight and preferred by the user.*

1. [Gotify](https://gotify.net/) - Self-hosted push notification server for sending messages to apps.  
   *Preferred alternative: [ntfy](https://ntfy.sh/) - simpler pub/sub notification system with mobile and CLI support.*

1. [LinkWarden](https://linkwarden.app/) — Bookmark manager for saving and organizing web links.  
   *Preferred alternative: [Wallabag](https://wallabag.org/) — read-it-later tool for saving articles and offline reading.*

1. [Portainer](https://www.portainer.io/) - Popular Docker management platform with UI, role-based access, and orchestration features.  
   *Preferred alternative: Dockhand (not linked) - lighter-weight and preferred by the user.*

1. [Piwigo](https://piwigo.org/) - Self-hosted photo gallery and management software.  
   *Preferred alternative: [Immich](https://immich.app/) - modern photo and video management with mobile app, ML-powered search, and face recognition.*

1. [Upscayl](https://upscayl.org/) — AI image upscaling tool for enhancing image resolution.  
   *Preferred alternative: [InvokeAI](https://invoke-ai.github.io/) - full generative AI suite with upscaling and image generation workflows.*

1. [Uptime Kuma](https://uptime.kuma.pet/) - Self-hosted monitoring tool for uptime and service checks.  
   *Preferred alternative: [Gatus](https://github.com/TwinProduction/gatus) - code-based health/status dashboard with GitOps-style configuration.*



## Similar Projects

* [Awesome Compose](https://github.com/docker/awesome-compose/) -  A starting point for integrating different services using a Compose file.
* [Docker compose collection](https://github.com/PAPAMICA/docker-compose-collection) Deploy multiple services easily and quickly.
* [Funky Penguin's Geek Cookbook](https://geek-cookbook.funkypenguin.co.nz/)
* [hotio.dev](https://hotio.dev/) - These are images not compose files, but very useful. 

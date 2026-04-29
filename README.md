<div align="center">
  <img src="_assets/heading.svg" alt="Description of SVG" width="800"/>
</div>

👤 Author: [Nick Yeoman](https://www.nickyeoman.com/).

Docker Compose file collection reference with the intent of running in production.

## Requirements and Support

I'm only one guy, I tested with

| Software            | Version   |
|---------------------|-----------|
| Debian              | 13        |
| Docker Engine       | 29.4.1    |
| Dockhand            | 1.0.26    |

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
docker compose --env-file sample.env --env-file down
```

Multiple --env-file flags are supported and applied in order.

## Prefered Containers

- UptimeKuma - I prefer Gatus over UptimeKuma and have removed support for UptimeKuma.

## Similar Projects

* [Awesome Compose](https://github.com/docker/awesome-compose/) -  A starting point for integrating different services using a Compose file.
* [Docker compose collection](https://github.com/PAPAMICA/docker-compose-collection) Deploy multiple services easily and quickly.
* [hotio.dev](https://hotio.dev/) - These are images not compose files, but very useful. 

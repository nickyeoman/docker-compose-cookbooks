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
| Docker Engine       | 29.2.1    |
| Dockhand            | 1.0.18    |

## 🤔 Assumptions

These compose files make a few assumptions:

1. You are running dockhand.
2. You are using Nginx Proxy Manager (although most have redundant port access).


## 📚 Workflow
The intended workflow is as follows:

1. Add the repository ```https://github.com/nickyeoman/docker-compose-cookbooks.git``` to your dockhand Git repositories (in settings)
1. Create the stack in dockhand

You may have to use multiple containers, such as Maria or postgres for db. 

## 🛠 Project Directory Structure

Directories ending with _dev contain projects that are still under development or experimental. These are not yet considered production-ready.

Directories ending with _notes contain projects that usually don’t require a full Docker Compose file. They may include notes, example commands, or minimal Compose files just to illustrate setup. For example, the ollama project has a docker-compose.yml showing CPU vs GPU usage.

### Decisions

#### container_name 

As we are going to rely on COMPOSE_PROJECT_NAME to create our project names, container_name has been left out of the template intentionally.

#### Paths

I use 3 Paths strategies, they are all considered private:

1. VOL_PATH, usually ./data is a data directory that is not in git, backed up externally.
1. CONFIG_PATH usually ./config is stored in git (text files)
1. LOG_PATH, usually ./logs is not stored in git or backed up.

## Similar Projects

* [Awesome Compose](https://github.com/docker/awesome-compose/) -  A starting point for integrating different services using a Compose file.
* [Docker compose collection](https://github.com/PAPAMICA/docker-compose-collection) Deploy multiple services easily and quickly.
* [hotio.dev](https://hotio.dev/) - These are images not compose files, but very useful. 

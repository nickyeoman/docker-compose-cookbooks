<div align="center">
  <img src="_assets/heading.svg" alt="Description of SVG" width="800"/>
</div>

👤 Author: [Nick Yeoman](https://www.nickyeoman.com/).

Docker Compose file collection reference with the intent of running in production.

## Requirements and Support

* Minimum Docker Engine: 20.10.0
* Minimum Docker Compose CLI: v2.0.0

## 🤔 Assumptions

These compose files make a few assumptions:

1. You are only running on one host.
2. You are using Nginx Proxy Manager (although most have redundant port access).
3. Volumes are stored in the project folder under "data", git ignored and backed up externally.

## 📚 Workflow
The intended workflow is as follows:

1. Copy cookbook.env to .env of your project
1. Copy the docker-compse.yml file to your project
1. Concatonate the sample.env to .env in your project
1. OPTIONAL: concatonate network.yml into your docker-compose.yml

You may have to use multiple containers, such as Maria or postgres for db. 

### Decisions

#### container_name 

As we are going to rely on COMPOSE_PROJECT_NAME to create our project names, container_name has been left out of the template intentionally.

#### Paths

I use 3 Paths strategies:

1. VOL_PATH, usually ./data is a data directory that is not in git, backed up externally.
1. CONFIG_PATH usually ./config is stored in git (text files)
1. LOG_PATH, usually ./logs is not stored in git or backed up.

## Similar Projects

* [Awesome Compose](https://github.com/docker/awesome-compose/) -  A starting point for integrating different services using a Compose file.
* [Docker compose collection](https://github.com/PAPAMICA/docker-compose-collection) Deploy multiple services easily and quickly.
* [hotio.dev](https://hotio.dev/) - These are images not compose files, but very useful. 

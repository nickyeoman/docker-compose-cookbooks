<div align="center">
  <img src="_assets/heading.svg" alt="Description of SVG" width="800"/>
</div>

👤 Author: [Nick Yeoman](https://www.nickyeoman.com/).

Production ready docker compose files

## 🤔 Assumptions

These compose files make a few assumptions:

1. You are only running on one host.
2. You are using Nginx Proxy Manager (although most have redundant port access).
3. Volumes are stored in the project folder under "data", git ignored and backed up externally.

## 📚 Workflow
The intended workflow is as follows:

1. Clone the cookbook repository locally ```git clone git@github.com:nickyeoman/docker-compose-cookbooks.git /docker-compose-cookbooks```
2. Change to the directory ```cd /git-repos/docker-compose-cookbooks```

You will likely want to override a number of things in the project folder, such as networks.

Now use ```docker compose up -d``` to start the project.

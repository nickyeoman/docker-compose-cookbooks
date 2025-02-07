<div align="center">
  <img src="_assets/heading.svg" alt="Description of SVG" width="800"/>
</div>

👤 Author: [Nick Yeoman](https://www.nickyeoman.com/).

These cookbooks are created with the intent of using Docker's extend feature. This way, you can run multiple containers in different domains but still have only one file to update.

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

## 🔍 Example Result

Here is an example of how your project's docker-compose file might look:

```yaml
services:
  proxy:
    extends:
      file: ${COOKBOOK}/nginx-proxy-manager/docker-compose.yml
      service: proxy
    env_file:
      - .env
    networks:
      - proxy

networks:
  proxy:
    external: true
```

with the .env file:

```text
COOKBOOK=/docker-compose-cookbooks
COMPOSE_PROJECT_NAME=www-4lt-ca
TZ=America/Vancouver
VOL_CONFIG_PATH=/websites/www-4lt-ca/config
VOL_PATH=/websites/www-4lt-ca/data
```

Now use ```docker compose up -d``` to start the project.

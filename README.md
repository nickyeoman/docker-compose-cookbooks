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

1. Clone the cookbook repository locally ```git clone git@github.com:nickyeoman/docker-compose-cookbooks.git /git-repos/docker-compose-cookbooks```
2. Change to the directory ```cd /git-repos/docker-compose-cookbooks```
3. Run the helper cli wizard: ```bash helper.bash```
4. Commit the new project to git.

You will likely want to override a number of things in the project folder, such as networks.

## 🔍 Example Result

Here is an example of how your project's docker-compose file might look:

```yaml
version: '3.4'

networks:
  proxy:
    external: true

services:
  proxy:
    extends:
      file: ${COOKBOOK}/nginx-proxy-manager/docker-compose.yml
      service: proxy
    env_file:
      - .env
    networks:
      - proxy
```

with the .env file:

```text
COOKBOOK=/git-repos/docker-compose-cookbooks
```

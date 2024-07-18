# Nick Yeoman's Collection of Docker compose files

Author: [Nick Yeoman](https://www.nickyeoman.com/).

These cookbooks are created with the intent of using Docker's extend feature. This way, you can run multiple containers in different domains but still have only one file to update.

These compose files make a few assumptions:

1. You are only running on one host.
2. You are using Nginx Proxy Manager (although most have redundant port access).
3. Volumes are stored in the project folder under "data", git ignored and backed up externally.

The intended workflow is as follows:

1. Clone the repository locally ```git clone git@github.com:nickyeoman/docker-compose-cookbooks.git /git-repos/docker-compose-cookbooks```
2. Create a project directory, usually by domain ```mkdir /projects/domainname-com```
3. Create a .env file in the project directory ```touch .env```
4. Add the COOKBOOK Variable to the project's env file: ```COOKBOOK=/git-repos/docker-compose-cookbooks```
5. Create a .gitignore file in the project directory and ignore "data/"
6. Create a docker-compose.yml file in the project directory with the external code given in the README file in the container folder.

## Example

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
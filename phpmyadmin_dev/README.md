# phpMyAdmin

## Overview

phpMyAdmin is a web-based MySQL/MariaDB database administration tool. This stack runs phpMyAdmin with arbitrary server connection support.

## Project Details

-   **Project Repository:** [https://github.com/phpmyadmin/phpmyadmin](https://github.com/phpmyadmin/phpmyadmin)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/phpmyadmin/phpmyadmin)
-   **Documentation:** [https://www.phpmyadmin.net/docs/](https://www.phpmyadmin.net/docs/)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:${PHPMYADMIN_PORT:-8083} in your browser
3. Log in with your database credentials

## Environment Variable Notes

    PHPMYADMIN_PMA_ARBITRARY – allow connecting to any database server (default: 1)
    PHPMYADMIN_PMA_HOST – default database host (default: mariadb)
    PHPMYADMIN_PMA_USER – default database user (default: root)
    PHPMYADMIN_PMA_PASSWORD – default database password (default: changeme)
    PHPMYADMIN_UPLOAD_LIMIT – maximum upload size (default: 200M)

## Volume Notes

No persistent volumes required.

## Network Notes

Requires the external `proxy` network (Nginx Proxy Manager). An internal bridge network `internal` is available for connecting to database containers.

## Docker Run

```bash
docker run -d \
  --name phpmyadmin \
  -e PMA_ARBITRARY=1 \
  -e PMA_HOST=mariadb \
  -e PMA_USER=root \
  -e PMA_PASSWORD=changeme \
  -e UPLOAD_LIMIT=200M \
  -p 8083:80 \
  --network proxy \
  phpmyadmin/phpmyadmin:latest
```

## Additional Notes / Gotchas

- Not for production use — there is no built-in authentication layer beyond the database credentials.
- Set `PMA_ARBITRARY=1` to connect to any database server by hostname at login time.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: PHPMYADMIN_DEV
Compose file path: phpmyadmin_dev/compose.yaml
Additional env file (optional): phpmyadmin_dev/sample.env

Then "Load" phpmyadmin_dev/sample.env into the Environmental variables in dockhand

Create the Stack

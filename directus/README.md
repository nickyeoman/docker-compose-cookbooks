# Directus

[official Website](https://directus.io/) and [Documentation](https://docs.directus.io/)

[Docker Hub](https://hub.docker.com/r/directus/directus)

Proxy port: 8055

## Other  Containers
You will also need mariadb and redis, something like:

```
  mariadb:
    image: ${MARIADB_IMAGE:-mariadb:latest}
    restart: unless-stopped
    environment:
      - MARIADB_DATABASE=${MARIADB_DATABASE}
      - MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD}
      - MARIADB_USER=${MARIADB_USER}
      - MARIADB_PASSWORD=${MARIADB_PASSWORD}
    volumes:
      - ${VOL_PATH}/mariadb:/var/lib/mysql
    
  cache:
    image: redis:6
    healthcheck:
      test: ["CMD-SHELL", "[ $$(redis-cli ping) = 'PONG' ]"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_interval: 5s
      start_period: 30s
```

## Gotacha

On first run: The initial admin email address and password will be shown in the terminal. 
If you forgot and did a detached: ```docker compose logs -f```

Reset password:
```bash
sudo nala install argon2
echo -n "TheNewPasswordHere" | argon2 "$(openssl rand -base64 16)" -id -m 16 -t 3 -p 4
```

# Docker Compose Template

Adopting an order/template to the docker compose files as follows:

```
# [App Name] Docker Compose Template (e.g., CORXN)

services:
  [service-name]:
    image: ${APPNAME_IMAGE_NAME:-user/name:latest}
    restart: ${APPNAME_RESTART:-unless-stopped}
    volumes:  # Templated with VOL_PATH, CONFIG_PATH or LOG_PATH
      - ${VOL_PATH:-./data}/appname/dir:/data
      - ${CONFIG_PATH:-./config}/appname/dir:/config
      - ${LOG_PATH:-./logs}/appname/dir:/var/logs
      - /etc/localtime:/etc/localtime:ro
    environment:  # Grouped: Universal first, app-specific after
      - TZ=${TZ:-UTC}
      - [APP_VAR1]=${[APP_VAR1]:-default}
      - [APP_VAR2]=${[APP_VAR2]:-default}
    ports: # Can remove this for proxy
      - "${APP_PORT:-9999}:9999"
    networks:
      - proxy
      - internal
    network_mode: "host"
    depends_on:
      - [db-service]  # e.g., mariadb
    healthcheck:  # Optional: App-specific
      test: ["CMD", "curl", "-f", "http://localhost:[port]"]
      interval: 30s
      timeout: 10s
      retries: 3
    labels:  # Optional
      - "traefik.enable=false"
    command:  # Override entrypoint if needed
    user: "1000:1000"  # Non-root
```
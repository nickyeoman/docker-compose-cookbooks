# Mailhog

TODO:

```
 mailhog:
    image: 'mailhog/mailhog:latest' # https://hub.docker.com/r/mailhog/mailhog
    ports:
      - "${SMTP_PORT}:1025"
      - "8002:8025"
    volumes:
      - "/etc/timezone:/etc/timezone:ro"
      - "/etc/localtime:/etc/localtime:ro"
```
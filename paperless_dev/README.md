# Paperless

proxy port: 8000


## First Run

It takes a very long time for the first run to initilaze, v
view the log to see when it's ready.

The ui will now create the first user for you, but we used to have to run:

```
docker exec -it paperless-ngx bash
python3 manage.py createsuperuser
```

## Configuration

All settings are controlled via environment variables in your `.env` file. Key variables include:

| Variable | Default | Description |
|----------|---------|-------------|
| `PAPERLESS_IMAGE` | `ghcr.io/paperless-ngx/paperless-ngx:latest` | Paperless Docker image |
| `PAPERLESS_MARIADB_HOST` | `paperless-db` | MariaDB host |
| `PAPERLESS_MARIADB_DATABASE` | `paperless` | Database name |
| `PAPERLESS_MARIADB_USER` | `paperless` | Database user |
| `PAPERLESS_MARIADB_PASSWORD` | `paperless` | Database password |
| `PAPERLESS_MARIADB_ROOT_PASSWORD` | `paperless` | MariaDB root password |
| `PAPERLESS_SECRET_KEY` | `changeme` | Secret key for Paperless |
| `PAPERLESS_OCR_LANGUAGE` | `eng` | OCR language for scanned documents |
| `VOL_PATH` | `./data` | Base path for volume storage |
| `TZ` | `America/Vancouver` | Timezone |

You can adjust these values in your `.env` (drived from `sample.env`) file before starting the containers.  

For the full list of available options, see the [Paperless-ngx configuration documentation](http://docs.paperless-ngx.com/configuration/).

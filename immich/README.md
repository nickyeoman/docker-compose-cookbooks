# Immich

* [Documentation](https://immich.app/docs/install/docker-compose/)
* [Documentation for env variables](https://immich.app/docs/install/environment-variables)

Reverse Poxy Port: 2283

## Import

1. Go the the Administrator and [External Libraries](http://localhost:8000/admin/library-management)
1. Choose the path: ```/import```
1. Place your files in the immich-import directory.
1. run the [Job](http://localhost:8000/admin/jobs-status) External Libraries

## Note

If the env file doesn't work after a change, try running ```docker compose up -d --force-recreate```.

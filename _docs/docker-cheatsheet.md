# Docker Cheatsheet

Reference: [Docker clean up guilde](https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430)

## Stop all containers

Stops all running Docker containers by fetching the IDs of all containers and passing them to the `docker stop` command.

```bash
docker stop $(docker ps -aq)
```
## Docker Prune

Cleans up unused Docker objects, including stopped containers, unused networks, dangling images, and build cache. This helps in reclaiming disk space by removing objects not referenced by any containers.

```bash
docker system prune
```
## Remove unused images

Deletes all Docker images that are not currently used by any containers. This command helps in freeing up space taken by old or unused images.

```bash
docker rmi $(docker images -q)
```

## Delete unused volumes

Removes Docker volumes that are not currently used by any container. This helps in clearing up space used by data volumes that are no longer needed.

```bash
docker volume rm $(docker volume ls -qf dangling=true)
docker volume ls -qf dangling=true | xargs -r docker volume rm
```

## Remove used networks

Cleans up unused Docker networks. The docker network prune command removes all unused networks, while the docker network rm command can be used to remove specific networks, such as the default "bridge" network if not needed.

```bash
docker network prune
docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
```

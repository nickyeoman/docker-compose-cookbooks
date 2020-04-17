#!/bin/bash

# Docker clean up guilde https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430

# kill all containers
docker stop $(docker ps -aq)

docker system prune

#remove all containers
#docker rm $(docker ps -aq)

#remove all images
#docker rmi $(docker images -q)

#delete all volumnes
#docker volume rm $(docker volume ls -qf dangling=true)
#docker volume ls -qf dangling=true | xargs -r docker volume rm

#remove all networks
docker network prune
#docker network ls
#docker network ls | grep "bridge"
#docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')

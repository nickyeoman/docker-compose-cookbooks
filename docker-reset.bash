#!/bin/bash

# Docker clean up guilde https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430

# kill all containers
echo "*** Killing All Containers ***"
docker stop $(docker ps -aq)

echo "*** Docker prune ***"
docker system prune

#remove all images
echo "*** Removing all Docker images ***"
docker rmi $(docker images -q)

#delete all volumnes
echo "*** Removing all Docker volumes ***"
docker volume rm $(docker volume ls -qf dangling=true)
docker volume ls -qf dangling=true | xargs -r docker volume rm

#remove all networks
echo "*** Removing all Docker Networks ***"
docker network prune
docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')

echo "*** All done ***"

#!/bin/sh

echo WARNING! This script is going to stop and delete your containers,
echo as well as your dangling images.

read -p "Continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    echo Stopping ALL containers...
    docker stop $(docker ps -a -q)
    echo Deleting ALL containers...
    docker rm $(docker ps -a -q)
    echo Deleting dangling images...
    docker rmi $(docker images -a --filter=dangling=true -q)
fi

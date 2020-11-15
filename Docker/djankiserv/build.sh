#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

set -e
set -x

if [ -n "$DOCKER_IMAGE" ] && [ -n "$DOCKER_IMAGE_ORG" ] && [ -n "$DOCKER_ADDITIONAL_BUILD_ARGS" ]; then
    git submodule update --init --recursive
    docker build $DOCKER_ADDITIONAL_BUILD_ARGS -t anki-sync-server:djankiserv .    
    docker tag anki-sync-server:djankiserv ankicommunity/anki-sync-server:djankiserv 
    docker tag anki-sync-server:djankiserv ankicommunity/anki-sync-server:latest 
else
    echo Please source ./vars first
    exit 1
fi

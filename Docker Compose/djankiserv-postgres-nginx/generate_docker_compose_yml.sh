#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

set -e
set -x

if [ -n "$DJANKISERV_VARS_SOURCED" ]; then
    envsubst < docker-compose.yml.in > docker-compose.yml
else
    echo Please source "Configuration/djankiserv.vars" first
    exit 1
fi

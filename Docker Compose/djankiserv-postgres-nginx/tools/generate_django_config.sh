#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

set -e
set -x

DJANKISERV_EXAMPLE_CONFIG_DIR="$DIR"/../../../Configuration/djankiserv_example_config
DJANKISERV_CONFIG_DIR="$DIR"/../djankiserv_config

if ! [ -n "$DJANKISERV_COMPOSE_VARS_SOURCED" ]; then
    echo Please source "Configuration/djankiserv_compose.vars"
    exit 1
fi

mkdir -p "$DJANKISERV_CONFIG_DIR"
cp -r "$DJANKISERV_EXAMPLE_CONFIG_DIR"/* "$DJANKISERV_CONFIG_DIR"

echo "DATABASE_PASSWORD=$DJANKISERV_DATABASE_PASSWORD" > "$DJANKISERV_CONFIG_DIR"/my_secrets.py

# envsubst < "$DIR"/generate_django_config/postgres_password.patch.orig > "$DIR"/generate_django_config/postgres_password.patch
# patch -D "$DJANKISERV_CONFIG_DIR" -i "$DIR"/generate_django_config/postgres_password.patch

# should create a secret.py instead...

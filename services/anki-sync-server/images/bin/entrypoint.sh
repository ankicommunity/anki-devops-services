#!/bin/sh
# file: entrypoint.sh

# allow entering shell if requested
# if any arguments are given
if [ "$#" -gt 0 ]; then
    # and the first one seems like the same of a executable
    # - either is itself executable
    # - or does not exist and is a command resolveable
    if [ -x "$1" ] || ( [ ! -e "$1" ] && command -v "$1" >/dev/null ); then
        # execute given argument like CMD
        # used env to ensure names like "bash" works as well as "/bin/bash"
        exec env "$@"
    fi
    echo "Forward given args to anki-sync-server: $*"
fi

# if [ -f "/app/data/auth.db" ]; then
#     echo "auth.db found"
# else
#     echo "Creating new authentication database: auth.db."
#     sqlite3 /app/data/auth.db 'CREATE TABLE auth (user VARCHAR PRIMARY KEY, hash VARCHAR)'
# fi

# echo "Updating database schema"
# python3 utils/migrate_user_tables.py

echo "Starting anki-sync-server"
python3 -m ankisyncd "$@"

#!/bin/sh
# file: entrypoint.sh

# if [ -f "/app/data/auth.db" ]; then
#     echo "auth.db found"
# else
#     echo "Creating new authentication database: auth.db."
#     sqlite3 /app/data/auth.db 'CREATE TABLE auth (user VARCHAR PRIMARY KEY, hash VARCHAR)'
# fi

# echo "Updating database schema"
# python3 utils/migrate_user_tables.py

echo "Starting anki-sync-server"
python3 -m ankisyncd
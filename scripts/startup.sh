#!/bin/sh

if [ -f "/app/data/ankisyncd.conf" ]; then
    echo "ankisyncd.conf found"
else
    echo "Creating new configuration file: ankisyncd.conf."
    cp "/app/anki-sync-server/ankisyncd.conf.example" "/app/data/ankisyncd.conf"
fi

if [ -f "/app/data/auth.db" ]; then
    echo "auth.db found"
else
    echo "Creating new authentication database: auth.db."
    sqlite3 /app/data/auth.db 'CREATE TABLE auth (user VARCHAR PRIMARY KEY, hash VARCHAR)'
fi

echo Startings tsudoko\'s anki-sync-server
python -m ankisyncd

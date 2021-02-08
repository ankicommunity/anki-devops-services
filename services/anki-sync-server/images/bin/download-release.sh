#!/bin/sh
# file: download-release.sh


mkdir -p release

cd release

git clone https://github.com/ankicommunity/anki-sync-server

mv anki-sync-server/src/* .

rm -rf anki-sync-server

cd ..
#!/bin/sh
# file: download-release.sh

set -eu

mkdir -p release

cd release

git clone https://github.com/ankicommunity/anki-sync-server

if [ "${ANKISYNCD_COMMIT}" != 'latest' ]; then
  cd anki-sync-server
  git checkout "${ANKISYNCD_COMMIT}"
  cd ..
fi

mv anki-sync-server/src/* .

rm -rf anki-sync-server

cd ..

#!/bin/sh
# file: download-release.sh


mkdir -p release

cd release

export ANKISYNCD_GIT_REPOSITORY_URL=https://github.com/ankicommunity/anki-sync-server
export ANKISYNCD_GIT_BRANCH=main
git clone ${ANKISYNCD_GIT_REPOSITORY_URL}
git checkout ${ANKISYNCD_GIT_BRANCH}

mv anki-sync-server/src/* .

rm -rf anki-sync-server

cd ..
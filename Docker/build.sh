#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"
git submodule update --init --recursive
docker build -t anki-sync-server:tsudoko-ankisyncd-2.1.0-plus-2bfccf7f .

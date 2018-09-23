#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"

docker run -it \
       --mount type=bind,source="$DIR/data",target=/app/data \
       anki-sync-server:tsudoku-2.1.4

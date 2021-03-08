#!/bin/bash
# file: preview-releases.sh
# description: run download-release.sh for all images.

pushd services/anki-sync-server/images

sh ./bin/download-release.sh

popd
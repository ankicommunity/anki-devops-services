FROM library/python:3.7.0-alpine3.8

LABEL maintainer="istvan@codekuklin.com"

ARG SERVER_COMMIT='8551021f2b2356e3c3449c1ea6b9745f0856af66'
ARG ANKI_COMMIT='cca3fcb2418880d0430a5c5c2e6b81ba260065b7'

SHELL ["/bin/sh", "-euxo", "pipefail", "-c"]

RUN  adduser ankisync -D -s /bin/false

RUN apk add --no-cache \
        build-base \
        portaudio-dev \
        sqlite \
 && pip install --no-cache-dir webob

COPY ./app /app

WORKDIR /app/anki-sync-server

RUN apk add --no-cache --virtual .install-deps git \
# Clone anki-sync-server
 && git clone -n https://github.com/kuklinistvan/anki-sync-server . \
 && git checkout ${SERVER_COMMIT} \
 && mv ankisyncd.conf ankisyncd.conf.example \
 && ln -s /app/config/ankisyncd.conf . \
# Clone anki
 && git clone -n https://github.com/dae/anki.git ./anki-bundled \
 && git --work-tree="anki-bundled" --git-dir="anki-bundled/.git" checkout ${ANKI_COMMIT} \
 && pip install --no-cache-dir -r ./anki-bundled/requirements.txt \
# Give the app to ankisync user
 && chown -R ankisync:ankisync /app \
 && chmod 700 /app \
# Cleanup
 && apk del .install-deps \
 && rm -rf \
        /app/anki-sync-server/.git* \
        /app/anki-sync-server/anki-bundled/.git*

USER ankisync

CMD ["/bin/sh","/app/scripts/startup.sh"]

EXPOSE 27701

HEALTHCHECK --interval=5s --timeout=3s CMD wget -q -O - http://127.0.0.1:27701/ || exit 1

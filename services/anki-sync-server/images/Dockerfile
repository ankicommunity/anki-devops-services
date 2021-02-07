# -- BUILDER --

FROM library/python:3.7-buster as builder

ARG ANKISYNCD_ROOT=/opt/ankisyncd
RUN mkdir -p ${ANKISYNCD_ROOT}
WORKDIR ${ANKISYNCD_ROOT}

COPY bin ./bin

RUN sh ./bin/download-release.sh && \
	pip3 install --upgrade pip && \
    pip3 install -r ./release/requirements.txt

# -- DEPLOYER --

FROM debian:buster-slim

ARG ANKISYNCD_PORT
ARG ANKISYNCD_DATA_ROOT
ARG ANKISYNCD_BASE_URL
ARG ANKISYNCD_BASE_MEDIA_URL
ARG ANKISYNCD_AUTH_DB_PATH
ARG ANKISYNCD_SESSION_DB_PATH

RUN apt-get update -y && \
    apt-get install -y python3 sqlite3 && \
    apt-get autoclean

COPY --from=builder /install/usr/lib/python3.7/site-packages/ /usr/lib/python3.7/dist-packages/

COPY anki-sync-server/src /app/anki-sync-server

WORKDIR /app/anki-sync-server

RUN mkdir /app/data && \
    mv /app/anki-sync-server/ankisyncd.conf /app/anki-sync-server/ankisyncd.conf.example && \
    ln -s /app/data/ankisyncd.conf /app/anki-sync-server/

COPY config /app/config

COPY bin /app/bin

RUN ln -s /usr/bin/python3 /usr/bin/python

CMD /app/bin/startup.sh

EXPOSE 27701

#HEALTHCHECK --interval=60s --timeout=3s CMD wget -q -O - http://127.0.0.1:27701/ || exit 1

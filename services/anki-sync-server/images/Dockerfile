# -- BUILDER --

FROM library/python:3.7-buster as builder

RUN apt-get update && \
	apt-get install -y sqlite3

RUN mkdir /install

WORKDIR /install

COPY anki-sync-server/src/requirements.txt /install/requirements.txt

RUN pip install --upgrade pip && \
    pip install --prefix=/usr --root /install -r /install/requirements.txt

# -- DEPLOYER --

FROM debian:buster-slim as deployer

ARG ANKISYNCD_PORT
ARG ANKISYNCD_DATA_PORT
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

COPY scripts /app/scripts

RUN ln -s /usr/bin/python3 /usr/bin/python

CMD /app/scripts/startup.sh

EXPOSE 27701

#HEALTHCHECK --interval=60s --timeout=3s CMD wget -q -O - http://127.0.0.1:27701/ || exit 1

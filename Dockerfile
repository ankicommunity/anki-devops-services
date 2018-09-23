FROM library/python:3.7.0-alpine3.8

RUN apk add build-base
RUN apk add portaudio-dev
RUN apk add sqlite
RUN pip install webob

COPY anki-sync-server /app/anki-sync-server

WORKDIR /app/anki-sync-server

RUN \
    cd anki-bundled && \
    pip install -r requirements.txt

RUN mkdir /app/data && \
    mv /app/anki-sync-server/ankisyncd.conf /app/anki-sync-server/ankisyncd.conf.example && \
    ln -s /app/data/ankisyncd.conf /app/anki-sync-server/

COPY config /app/config
COPY scripts /app/scripts
CMD /app/scripts/startup.sh

EXPOSE 27701

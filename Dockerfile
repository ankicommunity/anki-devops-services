FROM library/python:3.7.0-alpine3.8
COPY anki-sync-server /app/anki-sync-server

RUN apk add build-base
RUN apk add portaudio-dev
RUN apk add sqlite
RUN pip install webob

WORKDIR /app/anki-sync-server

RUN \
    cd anki-bundled && \
    pip install -r requirements.txt

RUN mkdir /app/data && \
    mv /app/anki-sync-server/ankisyncd.conf /app/data && \
    ln -s /app/data/ankisyncd.conf /app/anki-sync-server/


RUN sqlite3 /app/data/auth.db 'CREATE TABLE auth (user VARCHAR PRIMARY KEY, hash VARCHAR)' && \
    ln -s /app/data/auth.db /app/anki-sync-server

CMD python -m ankisyncd

EXPOSE 27701

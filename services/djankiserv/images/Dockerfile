FROM python:3.8.6-alpine3.12

LABEL maintainer="istvan@codekuklin.com"

# To override some packages while installling their dependencies from PyPI,
# you can use pypiserver with the --fallback option.
ARG INDEX_URL='https://pypi.org/simple'
ARG TRUSTED_HOST='127.0.0.1'

RUN apk add mariadb-connector-c-dev postgresql-dev gcc musl-dev

RUN pip3 install --index-url "${INDEX_URL}" --trusted-host "${TRUSTED_HOST}" djankiserv

RUN mkdir -p /home/app
RUN addgroup -S app && adduser -S app -G app -s /bin/sh

ENV HOME=/home/app
ENV APP_HOME=/home/app/

WORKDIR $APP_HOME

RUN apk add coreutils sudo

RUN django-admin startproject mysite
ENV PATH "$PATH:/home/app/mysite"

COPY views.py mysite/mysite/views.py

CMD cp /persistence/settings.py mysite/mysite/settings.py && \
    cp /persistence/mysecrets.py mysite/mysite/mysecrets.py && \
    cp /persistence/urls.py mysite/mysite/urls.py && \
    cd "$HOME" && yes yes | manage.py collectstatic && chmod 755 -R /home/app/static && \
        sudo -u app -H manage.py migrate && \
        sudo -u app -H manage.py runserver 0.0.0.0:8080

EXPOSE 8080
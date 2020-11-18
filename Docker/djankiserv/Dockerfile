FROM python:3.8.6-alpine3.12

LABEL maintainer="istvan@codekuklin.com"

#ARG SERVER_COMMIT='8551021f2b2356e3c3449c1ea6b9745f0856af66'

# To override some packages while installling their dependencies from PyPI,
# you can use pypiserver with the --fallback option.
ARG INDEX_URL='https://pypi.org/simple'
ARG TRUSTED_HOST='127.0.0.1'

RUN apk add mariadb-connector-c-dev postgresql-dev gcc musl-dev

RUN pip3 install --index-url "${INDEX_URL}" --trusted-host "${TRUSTED_HOST}" djankiserv

#RUN cp '/usr/local/lib/python3.8/site-packages/django/conf/project_template/manage.py-tpl' '/usr/bin/manage'
#COPY manage.py /usr/bin/manage
#CMD /usr/bin/manage migrate 



# Create the home directory for the new app user.
RUN mkdir -p /home/app

# Create an app user so our program doesn't run as root.
RUN addgroup -S app && adduser -S app -G app -s /bin/sh

# RUN groupadd -r app &&\
#     useradd -r -g app -d /home/app -s /sbin/nologin -c "Docker image user" app

ENV HOME=/home/app
ENV APP_HOME=/home/app/

#RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk add coreutils sudo

# USER app

RUN django-admin startproject mysite
ENV PATH "$PATH:/home/app/mysite"

#COPY settings.py mysite/mysite/settings.py

COPY views.py mysite/mysite/views.py

CMD cp /persistence/settings.py mysite/mysite/settings.py && \
    cd "$HOME" && yes yes | manage.py collectstatic && chmod 755 -R /home/app/static && \
    cp /persistence/urls.py mysite/mysite/urls.py && \
        sudo -u app -H manage.py migrate && \
        sudo -u app -H manage.py runserver 0.0.0.0:8080

EXPOSE 8080

# RUN apk add djankiserv

# RUN apk add build-base
# RUN apk add portaudio-dev
# RUN apk add sqlite
# RUN pip install webob

# COPY anki-sync-server /app/anki-sync-server

# WORKDIR /app/anki-sync-server

# RUN \
#     cd anki-bundled && \
#     pip install -r requirements.txt

# RUN mkdir /app/data && \
#     mv /app/anki-sync-server/ankisyncd.conf /app/anki-sync-server/ankisyncd.conf.example && \
#     ln -s /app/data/ankisyncd.conf /app/anki-sync-server/

# COPY config /app/config
# COPY scripts /app/scripts

# CMD /app/scripts/startup.sh

# EXPOSE 27701

# HEALTHCHECK --interval=5s --timeout=3s CMD wget -q -O - http://127.0.0.1:27701/ || exit 1

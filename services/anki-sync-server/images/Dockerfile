ARG ANKISYNCD_ROOT=/opt/ankisyncd
ARG PYTHONUSERBASE=/opt/venv

# -- BUILDER --
FROM library/python:3.9-buster as builder

ARG ANKISYNCD_ROOT
WORKDIR ${ANKISYNCD_ROOT}

ARG ANKISYNCD_GIT_REPOSITORY_URL
ARG ANKISYNCD_GIT_BRANCH
ARG ANKISYNCD_GIT_COMMIT_SHA
ARG ANKISYNCD_GIT_COMMIT_SHORT_SHA
ARG ANKISYNCD_GIT_COMMIT_TAG
COPY bin/download-release.sh ./bin/download-release.sh

ARG PYTHONUSERBASE
RUN sh ./bin/download-release.sh && \
	pip3 install --upgrade pip && \
    pip3 install --user -r ./release/requirements.txt

# -- DEPLOYER --
FROM python:3.9-slim-buster

# Label image with build information
ARG BUILD_USER_NAME
ARG BUILD_USER_EMAIL
ARG BUILD_DATE
ARG GIT_REPOSITORY_URL
ARG GIT_BRANCH
ARG GIT_COMMIT_SHA
ARG GIT_COMMIT_SHORT_SHA
ARG GIT_COMMIT_TAG
ARG GIT_DIRTY
ARG ANKISYNCD_GIT_REPOSITORY_URL
ARG ANKISYNCD_GIT_BRANCH
ARG ANKISYNCD_GIT_COMMIT_SHA
ARG ANKISYNCD_GIT_COMMIT_SHORT_SHA
ARG ANKISYNCD_GIT_COMMIT_TAG
LABEL org.ankicommunity.build.user.name=${BUILD_USER_NAME} \
	org.ankicommunity.build.user.email=${BUILD_USER_EMAIL} \
	org.ankicommunity.build.date=${BUILD_DATE} \
	org.ankicommunity.git.repository.url=${GIT_REPOSITORY_URL} \
	org.ankicommunity.git.branch=${GIT_BRANCH} \
	org.ankicommunity.git.commit.sha=${GIT_COMMIT_SHA} \
	org.ankicommunity.git.commit.short.sha=${GIT_COMMIT_SHORT_SHA} \
	org.ankicommunity.git.commit.tag=${GIT_COMMIT_TAG} \
	org.ankicommunity.git.dirty=${GIT_DIRTY} \
	org.ankicommunity.ankisyncd.git.repository.url=${ANKISYNCD_GIT_REPOSITORY_URL} \
	org.ankicommunity.ankisyncd.git.branch=${ANKISYNCD_GIT_BRANCH} \
	org.ankicommunity.ankisyncd.git.commit.sha=${ANKISYNCD_GIT_COMMIT_SHA} \
	org.ankicommunity.ankisyncd.git.commit.short.sha=${ANKISYNCD_GIT_COMMIT_SHORT_SHA} \
	org.ankicommunity.ankisyncd.git.commit.tag=${ANKISYNCD_GIT_COMMIT_TAG}

# Copy Python dependencies
ARG PYTHONUSERBASE
ENV PYTHONUSERBASE=${PYTHONUSERBASE}
COPY --from=builder ${PYTHONUSERBASE} ${PYTHONUSERBASE}

# Copy Anki Sync Server release and scripts
ARG ANKISYNCD_ROOT
COPY --from=builder ${ANKISYNCD_ROOT}/release ${ANKISYNCD_ROOT}
WORKDIR ${ANKISYNCD_ROOT}

# Create data volume.
ARG ANKISYNCD_DATA_ROOT=/srv/ankisyncd
VOLUME ${ANKISYNCD_DATA_ROOT}

# Set default environment variables.
ARG ANKISYNCD_PORT=27701
ARG ANKISYNCD_BASE_URL=/sync/
ARG ANKISYNCD_BASE_MEDIA_URL=/msync/
ARG ANKISYNCD_AUTH_DB_PATH=./auth.db
ARG ANKISYNCD_SESSION_DB_PATH=./session.db

ENV ANKISYNCD_HOST=0.0.0.0 \
	ANKISYNCD_PORT=${ANKISYNCD_PORT} \
	ANKISYNCD_DATA_ROOT=${ANKISYNCD_DATA_ROOT} \
	ANKISYNCD_BASE_URL=${ANKISYNCD_BASE_URL} \
	ANKISYNCD_BASE_MEDIA_URL=${ANKISYNCD_BASE_MEDIA_URL} \
	ANKISYNCD_AUTH_DB_PATH=${ANKISYNCD_AUTH_DB_PATH} \
	ANKISYNCD_SESSION_DB_PATH=${ANKISYNCD_SESSION_DB_PATH}

COPY bin/entrypoint.sh ./bin/entrypoint.sh

EXPOSE ${ANKISYNCD_PORT}

# TODO: Change to ENTRYPOINT. Currently CMD to allow shell access if needed.
CMD ["/bin/sh", "./bin/entrypoint.sh"]

HEALTHCHECK --interval=60s --timeout=3s CMD python -c "import requests; requests.get('http://127.0.0.1:${ANKISYNCD_PORT}/')"

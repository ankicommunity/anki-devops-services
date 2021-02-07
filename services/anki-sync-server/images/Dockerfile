# -- BUILDER --
FROM library/python:3.7-buster as builder

ARG ANKISYNCD_ROOT=/opt/ankisyncd
RUN mkdir -p ${ANKISYNCD_ROOT}
WORKDIR ${ANKISYNCD_ROOT}

COPY bin ./bin

ARG PYTHONUSERBASE=/opt/venv
RUN sh ./bin/download-release.sh && \
	pip3 install --upgrade pip && \
    pip3 install --user -r ./release/requirements.txt

# -- DEPLOYER --
FROM debian:buster-slim

# Copy Python dependencies
COPY --from=builder ${PYTHONUSERBASE} ${PYTHONUSERBASE}

# Copy Anki Sync Server release and scripts
ARG ANKISYNCD_ROOT=/opt/ankisyncd
COPY --from=builder ${ANKISYNCD_ROOT} ${ANKISYNCD_ROOT}
WORKDIR ${ANKISYNCD_ROOT}

# Set default environment variables.
ARG ANKISYNCD_PORT
ARG ANKISYNCD_DATA_ROOT
ARG ANKISYNCD_BASE_URL
ARG ANKISYNCD_BASE_MEDIA_URL
ARG ANKISYNCD_AUTH_DB_PATH
ARG ANKISYNCD_SESSION_DB_PATH

ENV ANKISYNCD_HOST=0.0.0.0 \
	ANKISYNCD_PORT=${ANKISYNCD_PORT} \
	ANKISYNCD_DATA_ROOT=${ANKISYNCD_DATA_ROOT} \
	ANKISYNCD_BASE_URL=${ANKISYNCD_BASE_URL} \
	ANKISYNCD_BASE_MEDIA_URL=${ANKISYNCD_BASE_MEDIA_URL} \
	ANKISYNCD_AUTH_DB_PATH=${ANKISYNCD_AUTH_DB_PATH} \
	ANKISYNCD_SESSION_DB_PATH=${ANKISYNCD_SESSION_DB_PATH}

EXPOSE ${ANKISYNCD_PORT}

CMD ["/bin/sh", "./bin/startup.sh"]

HEALTHCHECK --interval=60s --timeout=3s CMD wget -q -O - http://127.0.0.1:27701/ || exit 1

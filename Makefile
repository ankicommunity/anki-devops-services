#!/usr/bin/make

SHELL := /bin/bash
ANKI_DEVOPS_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ANKI_DEVOPS_NAME ?= "anki-devops-services"
ANKI_DEVOPS_VERSION ?= "v0.1.0"
ANKI_DEVOPS_DESCRIPTION ?= "Images and Containers for Anki Community services."

ENV := local
-include ${ANKI_DEVOPS_PATH}/config/.env.${ENV}
export

.DEFAULT_GOAL := help-devops
.PHONY: help-devops #: List available command.
help: help-devops # alias for quick access
help-devops:
	@cd "${ANKI_DEVOPS_PATH}" && awk 'BEGIN {FS = " ?#?: "; print ""${ANKI_DEVOPS_NAME}" "${ANKI_DEVOPS_VERSION}"\n"${ANKI_DEVOPS_DESCRIPTION}"\n\nUsage: make \033[36m<command>\033[0m\n\nCommands:"} /^.PHONY: ?[a-zA-Z_-]/ { printf "  \033[36m%-10s\033[0m %s\n", $$2, $$3 }' $(MAKEFILE_LIST)

.PHONY: run-devops #: Run examples.
run: run-devops # alias for quick access
run-devops:
	@cd "${ANKI_DEVOPS_PATH}" && \
	${BASH} scripts/run-devops.sh

.PHONY: build-devops #: Build images.
build: build-devops # alias for quick access
build-devops:
	@cd "${ANKI_DEVOPS_PATH}" && \
	${BASH} scripts/build-devops.sh


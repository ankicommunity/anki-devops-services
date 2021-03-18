#!/bin/bash
# file: run-devops.sh
# description:

run_example () {
	SERVICE=$1
	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/examples > /dev/null
	
	echo "--- Running Docker Examples."
	docker-compose up ${CONTAINER}

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	run_example $(basename ${service})
done

popd > /dev/null

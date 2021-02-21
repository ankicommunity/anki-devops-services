#!/bin/bash
# file: clean-devops.sh
# description: Clean all Docker images.

clean_images () {
	SERVICE=$1

	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	echo "--- Building Docker images."
	docker-compose down --rmi all

	# Exit with error if build fails
	if [[ $? == 1 ]]; then
		exit 1
	fi

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	clean_images $(basename ${service})
done

popd > /dev/null
#!/bin/bash
# file: build-devops.sh
# description: Build all Docker images

git_dirty () {
	if [[ $(git status --porcelain)  ]]; then 
		echo "true"; 
	else 
		echo "false";
	fi
}

build_image () {
	SERVICE=$1

	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	echo "--- Building Docker images."
	docker-compose build

	# Exit with error if build fails
	if [[ $? == 1 ]]; then
		exit 1
	fi

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

echo "--- BUILD_USER_NAME: ${BUILD_USER_NAME}"
echo "--- BUILD_USER_EMAIL: ${BUILD_USER_EMAIL}"
export BUILD_DATE=$(date '+%Y-%m-%d')
echo "--- BUILD_DATE: ${BUILD_DATE}"
export GIT_REPOSITORY_URL=$(git remote get-url origin)
echo "--- GIT_REPOSITORY_URL: ${GIT_REPOSITORY_URL}"
export GIT_BRANCH=$(git symbolic-ref --short -q HEAD)
echo "--- GIT_BRANCH: ${GIT_BRANCH}"
export GIT_COMMIT_SHA=$(git rev-parse HEAD)
echo "--- GIT_COMMIT_SHA: ${GIT_COMMIT_SHA}"
export GIT_COMMIT_SHORT_SHA=$(git rev-parse --short HEAD)
echo "--- GIT_COMMIT_SHORT_SHA: ${GIT_COMMIT_SHORT_SHA}"
export GIT_COMMIT_TAG=$(git describe --tags --abbrev=0)
echo "--- GIT_COMMIT_TAG: ${GIT_COMMIT_TAG}"
export GIT_DIRTY=$(git_dirty)
echo "--- GIT_DIRTY: ${GIT_DIRTY}"

for service in services/${SERVICE:=*}/ ; do
	build_image $(basename ${service})
done

popd > /dev/null
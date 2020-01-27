#!/bin/sh

export BUILD_NUMBER=$1
export DOCKER_IMAGE_NAME=$2
export BUILD_COMMIT_SHA=$3
export QUAY_USERNAME=$4
export QUAY_PASSWORD=$5

if [ "$#" -ne 5 ]; then
    echo "WRONG NUMBER OF PARAMETERS SUPPLIED TO ci-build.sh:"

    echo "BUILD_NUMBER: ${BUILD_NUMBER}"
    echo "DOCKER_IMAGE_NAME: ${DOCKER_IMAGE_NAME}"
    echo "BUILD_COMMIT_SHA: ${BUILD_COMMIT_SHA}"
    echo "QUAY_USERNAME: ${QUAY_USERNAME}"

    echo "EXPECTED USAGE:"
    echo "ci-build.sh [BUILD-NUMBER] [DOCKER_IMAGE_NAME] [BUILD_COMMIT_SHA] [QUAY_USERNAME] [QUAY_PASSWORD]"

    echo "USAGE EXAMPLE:"
    echo "ci-build.sh 123 docker.digital.homeoffice.gov.uk/srrs/srrs-tooling 123456789ABCD QUAY_user QUAY_password"

    exit 1
fi

echo "Username: ${QUAY_USERNAME}"

echo "-----"
echo "Building image ${DOCKER_IMAGE_NAME}"

if docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_COMMIT_SHA} -t ${DOCKER_IMAGE_NAME}:latest -f Dockerfile . ; then
    echo "Finished building docker image"
else
    echo "Failed building docker image"
    exit 1
fi

echo "-----"
echo "Pushing new docker image: ${DOCKER_IMAGE_NAME}"

if docker login -u=${QUAY_USERNAME} -p=${QUAY_PASSWORD} quay.io ; then
    echo "Logged in to quay.io"
else
    echo "Cannot login to quay.io Please check user and password"
    exit 1
fi

if docker push ${DOCKER_IMAGE_NAME}:${BUILD_COMMIT_SHA} ; then
    echo "Pushed ${DOCKER_IMAGE_NAME}:${BUILD_COMMIT_SHA} image to quay.io"
else
    echo "Cannot push image to quay.io Please check write permissions"
    exit 1
fi

# Tag image as latest
if docker push ${DOCKER_IMAGE_NAME}:latest ; then
    echo "Pushed ${DOCKER_IMAGE_NAME}:latest image to quay.io"
else
    echo "Cannot push image to quay.io Please check write permissions"
    exit 1
fi

exit 0

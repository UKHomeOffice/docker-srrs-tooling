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

echo "QUAY_USERNAME: ${QUAY_USERNAME}"
echo "PWD: ${PWD}"

export DOCKER_CONTAINER_NAME=tmp-${BUILD_NUMBER}
echo "DOCKER_CONTAINER_NAME: ${DOCKER_CONTAINER_NAME}"

echo "-----"
echo "PWD folder:"
ls -a ${PWD}
echo "-----"

echo "-----"
echo "Building image ${DOCKER_IMAGE_NAME}"
if docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_COMMIT_SHA} -t ${DOCKER_IMAGE_NAME}:latest -f Dockerfile . ; then
    echo "Finished building docker image"
else
    echo "Failed building docker image"
    exit 1
fi

echo "-----"
echo "Pushing new Docker image: ${DOCKER_IMAGE_NAME}"
docker login -u=${QUAY_USERNAME} -p=${QUAY_PASSWORD} quay.io
docker push ${DOCKER_IMAGE_NAME}:${BUILD_COMMIT_SHA}
docker push ${DOCKER_IMAGE_NAME}:latest

exit 0
#!/bin/bash
# Set these environment variables
#DOCKER_USER=
#DOCKER_AUTH=

set -e

ORG=${ORG:-hsldevcom}
DOCKER_TAG=${TRAVIS_COMMIT:-latest}
DOCKER_IMAGE=$ORG/pelias-api
DOCKER_IMAGE_COMMIT=$DOCKER_IMAGE:$DOCKER_TAG
DOCKER_IMAGE_LATEST=$DOCKER_IMAGE:latest
DOCKER_IMAGE_PROD=$DOCKER_IMAGE:prod

if [ -z $TRAVIS_TAG ]; then
    # Build image
    echo "Building pelias-api"
    docker build --tag="$DOCKER_IMAGE_COMMIT" .
fi

if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    docker login -u $DOCKER_USER -p $DOCKER_AUTH
    if [ "$TRAVIS_TAG" ];then
        echo "processing release $TRAVIS_TAG"
        docker pull $DOCKER_IMAGE_COMMIT
        docker tag $DOCKER_IMAGE_COMMIT $DOCKER_IMAGE_PROD
        docker push $DOCKER_IMAGE_PROD
    else
        echo "Pushing latest image"
        docker push $DOCKER_IMAGE_COMMIT
        docker tag $DOCKER_IMAGE_COMMIT $DOCKER_IMAGE_LATEST
        docker push $DOCKER_IMAGE_LATEST
    fi
fi


echo Build completed

#!/bin/sh

VERSION=latest
IMAGE=rd_challenge:$VERSION

# Checks if image is already built 
if [ -z "$(docker images -q $IMAGE 2> /dev/null)" ];
then
  echo "Building docker image: $IMAGE..."
  docker build -t $IMAGE .
  docker run $IMAGE
else
  echo "Running image: $IMAGE..."
  docker run $IMAGE
fi


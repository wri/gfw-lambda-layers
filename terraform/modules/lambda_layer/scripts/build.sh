#!/usr/bin/env bash

set -e

GIT_SHA="$(git rev-parse HEAD | cut -c 1-8)"

LAYER_PATH=${1}
IMAGE="globalforestwatch/${2}"


echo "BUILD image ${IMAGE}"
docker build --no-cache -t "${IMAGE}":"${GIT_SHA}" -f "${LAYER_PATH}"/Dockerfile .

echo "CREATE container"
docker run --name lambda_layer -itd "${IMAGE}":"${GIT_SHA}" /bin/bash

echo "COPY ZIP package to host"
docker cp lambda_layer:/opt/layer.zip "${LAYER_PATH}"/layer.zip

echo "REMOVE container"
docker rm -f lambda_layer

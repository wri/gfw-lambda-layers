#!/usr/bin/env bash

set -e

LAYER_PATH=${1}
IMAGE="globalforestwatch/${2}"

pushd "${LAYER_PATH}"

echo "BUILD image ${IMAGE}"
docker build --no-cache -t "${IMAGE}"  .

echo "CREATE container"
docker run --name lambda_layer -itd "${IMAGE}" /bin/bash

echo "COPY ZIP package to host"
docker cp lambda_layer:/opt/layer.zip layer.zip

echo "REMOVE container"
docker rm -f lambda_layer

popd
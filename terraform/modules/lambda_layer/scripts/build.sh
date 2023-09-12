#!/usr/bin/env bash

set -e

LAYER_PATH=${1}
IMAGE="globalforestwatch/${2}"

echo ${LAYER_PATH} > ${LAYER_PATH}/foo.txt
date >> ${LAYER_PATH}/foo.txt
CONTAINER_NAME=container_"$(sha1sum ${LAYER_PATH}/foo.txt |cut -c 1-8)"

pushd "${LAYER_PATH}"

echo "BUILD image ${IMAGE}"
docker build --no-cache -t "${IMAGE}"  .

echo "CREATE container ${CONTAINER_NAME}"
docker run --name ${CONTAINER_NAME} -itd "${IMAGE}":"${GIT_SHA}" /bin/bash

echo "COPY ZIP package to host"
docker cp ${CONTAINER_NAME}:/opt/layer.zip layer.zip

echo "STOP container"
docker stop ${CONTAINER_NAME}
docker wait ${CONTAINER_NAME}

echo "REMOVE container"
docker rm -f ${CONTAINER_NAME}

popd
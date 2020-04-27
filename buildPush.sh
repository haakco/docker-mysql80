#!/usr/bin/env bash
IMAGE_NAME=haakco/mysql80
docker build --pull --rm -t ${IMAGE_NAME} .
docker push "${IMAGE_NAME}"

#!/usr/bin/env bash

docker build -f Dockerfile -t pharosproduction/quorum:2.7.0 .
docker push pharosproduction/quorum:2.7.0
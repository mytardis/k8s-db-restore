#!/bin/sh

# Build
docker build . --squash -t mytardis/k8s-db-restore:latest

# Push
docker push mytardis/k8s-db-restore:latest

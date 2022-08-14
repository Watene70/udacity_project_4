#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
dockerpath=nate233/ml

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login -u nate233
docker image tag ml $dockerpath
# Step 3:
docker push $dockerpath

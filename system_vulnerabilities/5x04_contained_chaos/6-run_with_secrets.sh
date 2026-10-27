#!/bin/bash
# Run DevStream with secrets provided at runtime

set -euo pipefail

IMAGE="devstream-nosecrets:v1"
CONTAINER="devstream-nosecrets-test"

# Request configuration at runtime
read -r -p "DB Host: " DB_HOST
read -r -p "DB User: " DB_USER
read -r -s -p "DB Password: " DB_PASSWORD
echo

# Validate input
if [ -z "$DB_HOST" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "ERROR: All database settings are required."
    exit 1
fi

echo "Building Docker image..."
docker build -t "$IMAGE" -f Dockerfile .

# Remove previous test container if it exists
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

echo "Starting container with runtime environment variables..."

docker run -d \
    --name "$CONTAINER" \
    --network none \
    -e DB_HOST \
    -e DB_USER \
    -e DB_PASSWORD \
    "$IMAGE" >/dev/null

# Remove password from the shell variable
unset DB_PASSWORD

echo "Container started: $CONTAINER"
echo "Image: $IMAGE"
echo "Secrets were not hardcoded in the Dockerfile."

echo
echo "Checking application..."
docker ps --filter "name=$CONTAINER"

echo
echo "To stop and remove the container:"
echo "  docker rm -f $CONTAINER"

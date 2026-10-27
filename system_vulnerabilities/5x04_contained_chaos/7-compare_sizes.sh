#!/bin/bash
# Compare single-stage and multi-stage Docker images

set -euo pipefail

SINGLE_IMAGE="devstream-vulnerable:latest"
MULTI_IMAGE="devstream-multistage:v1"

echo "Building multi-stage image..."
docker build -t "$MULTI_IMAGE" -f Dockerfile .

if ! docker image inspect "$SINGLE_IMAGE" >/dev/null 2>&1; then
    echo "ERROR: Single-stage image not found."
    echo "Build the vulnerable image from Task 1 first."
    exit 1
fi

# Get image sizes in bytes
SINGLE_SIZE=$(docker image inspect "$SINGLE_IMAGE" \
    --format '{{.Size}}')

MULTI_SIZE=$(docker image inspect "$MULTI_IMAGE" \
    --format '{{.Size}}')

# Convert to MB and calculate reduction
awk -v single="$SINGLE_SIZE" -v multi="$MULTI_SIZE" '
BEGIN {
    single_mb = single / 1024 / 1024
    multi_mb = multi / 1024 / 1024
    reduction = (single - multi) / single * 100

    printf "Single-stage image: %.0f MB\n", single_mb
    printf "Multi-stage image: %.0f MB\n", multi_mb
    printf "Reduction: %.0f%%\n", reduction
}'

echo
echo "Packages in final image:"
echo "  Python:"
docker run --rm --entrypoint python "$MULTI_IMAGE" --version

echo "  Flask:"
docker run --rm --entrypoint python "$MULTI_IMAGE" \
    -m pip show flask | grep '^Version:' || true

echo
echo "Build tools excluded:"

for tool in gcc make; do
    if docker run --rm --entrypoint /bin/sh "$MULTI_IMAGE" \
        -c "command -v $tool" >/dev/null 2>&1; then
        echo "  $tool: PRESENT"
    else
        echo "  $tool: EXCLUDED"
    fi
done

echo
echo "Checking non-root user:"
docker run --rm --entrypoint id "$MULTI_IMAGE"

echo
echo "Multi-stage build comparison complete."

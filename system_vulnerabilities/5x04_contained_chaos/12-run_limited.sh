#!/bin/bash
# Run DevStream container with resource limits

set -euo pipefail

IMAGE="devstream-health:v1"
CONTAINER="devstream-limited"

echo "Applying limits:"
echo "  --memory=256m (max 256MB RAM)"
echo "  --memory-swap=256m (no swap)"
echo "  --cpus=0.5 (max 50% of one CPU)"
echo "  --pids-limit=50 (max 50 processes)"

# Check image
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "ERROR: Image $IMAGE not found."
    exit 1
fi

# Remove previous container if present
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

# Start container with resource limits
docker run -d \
    --name "$CONTAINER" \
    --memory=256m \
    --memory-swap=256m \
    --cpus=0.5 \
    --pids-limit=50 \
    --cap-drop=ALL \
    --security-opt no-new-privileges:true \
    "$IMAGE" >/dev/null

echo "Container started: $CONTAINER"

echo "Verification:"

# Inspect applied limits
MEMORY=$(docker inspect "$CONTAINER" \
    --format '{{.HostConfig.Memory}}')

MEMORY_SWAP=$(docker inspect "$CONTAINER" \
    --format '{{.HostConfig.MemorySwap}}')

NANO_CPUS=$(docker inspect "$CONTAINER" \
    --format '{{.HostConfig.NanoCpus}}')

PIDS=$(docker inspect "$CONTAINER" \
    --format '{{.HostConfig.PidsLimit}}')

# Verify expected values
if [ "$MEMORY" -eq 268435456 ]; then
    echo "  Memory limit: 256MB"
else
    echo "  Memory limit: INCORRECT ($MEMORY bytes)"
    exit 1
fi

if [ "$MEMORY_SWAP" -eq 268435456 ]; then
    echo "  Swap limit: No additional swap"
else
    echo "  Swap limit: INCORRECT"
    exit 1
fi

if [ "$NANO_CPUS" -eq 500000000 ]; then
    echo "  CPU limit: 0.5 cores"
else
    echo "  CPU limit: INCORRECT"
    exit 1
fi

if [ "$PIDS" -eq 50 ]; then
    echo "  PID limit: 50"
else
    echo "  PID limit: INCORRECT"
    exit 1
fi

# Wait for application startup
APP_READY=false

for i in $(seq 1 15); do
    if docker exec "$CONTAINER" python -c \
        "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2)" \
        >/dev/null 2>&1; then
        APP_READY=true
        break
    fi
    sleep 2
done

if [ "$APP_READY" = true ]; then
    echo "Application status: Running normally"
else
    echo "Application status: FAILED"
    docker logs "$CONTAINER"
    exit 1
fi

echo "Resource limits active."
echo "Container resource consumption is restricted."

#!/bin/bash
# Run DevStream with minimal Linux capabilities

set -euo pipefail

IMAGE="devstream-health:v1"
CONTAINER="devstream-secure"

echo "Dropping all capabilities..."
echo "Adding back only required capabilities:"
echo "  (none needed for this application)"

# Check Docker image
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "ERROR: Image $IMAGE not found."
    echo "Build the image from Task 8 first."
    exit 1
fi

# Remove previous container if it exists
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

echo "Starting container..."

docker run -d \
    --name "$CONTAINER" \
    --cap-drop=ALL \
    --security-opt no-new-privileges:true \
    "$IMAGE" >/dev/null

echo "  Container: $CONTAINER"
echo "  Capabilities: NONE"

echo
echo "Verification:"
echo "  docker exec $CONTAINER cat /proc/1/status | grep Cap"

# Read capabilities of the main application process
CAPS=$(docker exec "$CONTAINER" \
    cat /proc/1/status | grep '^Cap')

echo "$CAPS"

# Verify permitted and effective capabilities
CAP_PRM=$(echo "$CAPS" | awk '/^CapPrm:/ {print $2}')
CAP_EFF=$(echo "$CAPS" | awk '/^CapEff:/ {print $2}')

if [ "$CAP_PRM" != "0000000000000000" ] || \
   [ "$CAP_EFF" != "0000000000000000" ]; then
    echo "ERROR: Elevated capabilities detected!"
    exit 1
fi

echo
echo "Checking application..."

# Wait for Flask to become ready (maximum 30 seconds)
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

echo
echo "The container has ZERO elevated capabilities."
echo "Even if compromised, the attacker's abilities are limited."

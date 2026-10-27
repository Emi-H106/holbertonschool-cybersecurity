#!/bin/bash
# Run DevStream with a read-only root filesystem

set -euo pipefail

IMAGE="devstream-health:v1"
CONTAINER="devstream-readonly"

echo "Starting container with:"
echo "  --read-only"
echo "  --tmpfs /tmp (for temporary files)"
echo "  --tmpfs /app/logs (for application logs)"

# Check image
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "ERROR: Image $IMAGE not found."
    exit 1
fi

# Remove previous test container
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

# Start container with read-only filesystem
docker run -d \
    --name "$CONTAINER" \
    --read-only \
    --tmpfs /tmp:rw,nosuid,nodev,size=64m,mode=1777 \
    --tmpfs /app/logs:rw,nosuid,nodev,size=16m,uid=1000,gid=1000,mode=0750 \
    --cap-drop=ALL \
    --security-opt no-new-privileges:true \
    "$IMAGE" >/dev/null

echo
echo "Verification:"

# Verify /etc is not writable
if docker exec "$CONTAINER" sh -c \
    'touch /etc/readonly-test' >/dev/null 2>&1; then
    echo "  Attempt to write to /etc: ALLOWED (UNSAFE)"
    exit 1
else
    echo "  Attempt to write to /etc: BLOCKED"
fi

# Verify /app is not writable
if docker exec "$CONTAINER" sh -c \
    'touch /app/readonly-test' >/dev/null 2>&1; then
    echo "  Attempt to write to /app: ALLOWED (UNSAFE)"
    exit 1
else
    echo "  Attempt to write to /app: BLOCKED"
fi

# Verify /tmp is writable
if docker exec "$CONTAINER" sh -c \
    'touch /tmp/readonly-test && rm /tmp/readonly-test'; then
    echo "  Attempt to write to /tmp: ALLOWED"
else
    echo "  Attempt to write to /tmp: BLOCKED (ERROR)"
    exit 1
fi

# Verify application log directory is writable
if docker exec "$CONTAINER" sh -c \
    'echo "Test log entry" > /app/logs/test.log'; then
    echo "  Application logging: WORKING"
else
    echo "  Application logging: FAILED"
    exit 1
fi

# Verify root filesystem setting
READ_ONLY=$(docker inspect "$CONTAINER" \
    --format '{{.HostConfig.ReadonlyRootfs}}')

if [ "$READ_ONLY" = "true" ]; then
    echo "Root filesystem: READ-ONLY"
else
    echo "Root filesystem: WRITABLE (UNSAFE)"
    exit 1
fi

# Wait for Flask to become ready
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

echo "Attackers cannot modify the read-only root filesystem."

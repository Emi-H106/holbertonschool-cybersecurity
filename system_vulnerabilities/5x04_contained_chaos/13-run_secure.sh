#!/bin/bash
# Run DevStream container with additional security hardening

set -euo pipefail

IMAGE="devstream-health:v1"
CONTAINER="devstream-secure-final"

echo "Security options applied:"
echo "  --security-opt=no-new-privileges:true"
echo "    (Process cannot gain new privileges via setuid, etc.)"
echo "  --security-opt=seccomp=builtin"
echo "    (Docker default syscall filtering enabled)"

echo "Additional hardening:"
echo "  --cap-drop=ALL"
echo "  --read-only"
echo "  --user=appuser"

# Check Docker image
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "ERROR: Image $IMAGE not found."
    exit 1
fi

# Remove previous container
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

# Run hardened container
docker run -d \
    --name "$CONTAINER" \
    --security-opt=no-new-privileges:true \
    --security-opt=seccomp=builtin \
    --cap-drop=ALL \
    --read-only \
    --tmpfs /tmp:rw,nosuid,nodev,size=64m,mode=1777 \
    --tmpfs /app/logs:rw,nosuid,nodev,size=16m,uid=1000,gid=1000,mode=0750 \
    --user=appuser \
    "$IMAGE" >/dev/null

echo "Container started with maximum hardening."

echo "Security verification:"

# Verify no-new-privileges
NO_NEW_PRIVS=$(docker exec "$CONTAINER" \
    sh -c "grep '^NoNewPrivs:' /proc/1/status | awk '{print \$2}'")

if [ "$NO_NEW_PRIVS" = "1" ]; then
    echo "  New privileges: BLOCKED"
else
    echo "  New privileges: NOT BLOCKED"
    exit 1
fi

# Verify seccomp mode
SECCOMP=$(docker exec "$CONTAINER" \
    sh -c "grep '^Seccomp:' /proc/1/status | awk '{print \$2}'")

if [ "$SECCOMP" = "2" ]; then
    echo "  Seccomp: ENABLED"
else
    echo "  Seccomp: DISABLED"
    exit 1
fi

# Verify non-root user
USER_ID=$(docker exec "$CONTAINER" id -u)

if [ "$USER_ID" != "0" ]; then
    echo "  Root access: NONE"
else
    echo "  Root access: DETECTED"
    exit 1
fi

# Verify capabilities
CAP_EFF=$(docker exec "$CONTAINER" \
    sh -c "grep '^CapEff:' /proc/1/status | awk '{print \$2}'")

if [ "$CAP_EFF" = "0000000000000000" ]; then
    echo "  Capabilities: NONE"
else
    echo "  Capabilities: DETECTED"
    exit 1
fi

# Verify read-only filesystem
READ_ONLY=$(docker inspect "$CONTAINER" \
    --format '{{.HostConfig.ReadonlyRootfs}}')

if [ "$READ_ONLY" = "true" ]; then
    echo "  Root filesystem: READ-ONLY"
else
    echo "  Root filesystem: WRITABLE"
    exit 1
fi

# Wait for Flask application
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
    echo "  Application: RUNNING"
else
    echo "  Application: FAILED"
    docker logs "$CONTAINER"
    exit 1
fi

echo "Security hardening verification completed."

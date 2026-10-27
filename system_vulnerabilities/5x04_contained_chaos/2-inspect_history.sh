#!/bin/bash
# Inspect Docker image history and extract exposed secrets

set -euo pipefail

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image_name>"
    exit 1
fi

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Error: Image '$IMAGE' not found."
    exit 1
fi

echo "Image: $IMAGE"
echo "Layer History:"

# Get full Docker image history
HISTORY=$(docker history --no-trunc \
    --format '{{.CreatedBy}}' "$IMAGE")

# Display history from oldest to newest
echo "$HISTORY" | tac | \
awk '
{
    line = $0

    if (line ~ /chpasswd/) {
        line = line "  <-- PASSWORD EXPOSED"
    }

    if (line ~ /DB_PASSWORD=/) {
        line = line "  <-- SECRET EXPOSED"
    }

    printf "  Layer %d: %s\n", NR, line
}'

echo
echo "Extracting secrets from history..."

# Extract root password from RUN command
ROOT_PASSWORD=$(printf '%s\n' "$HISTORY" | \
    sed -n "s/.*root:\([^'[:space:]]*\).*chpasswd.*/\1/p" | \
    head -n 1)

# Extract DB password from ENV instruction
DB_PASSWORD=$(printf '%s\n' "$HISTORY" | \
    sed -n 's/.*DB_PASSWORD=\([^[:space:]]*\).*/\1/p' | \
    head -n 1)

# Fallback: read image environment metadata
if [ -z "$DB_PASSWORD" ]; then
    DB_PASSWORD=$(docker image inspect "$IMAGE" \
        --format '{{range .Config.Env}}{{println .}}{{end}}' | \
        sed -n 's/^DB_PASSWORD=//p')
fi

echo "  Root password: ${ROOT_PASSWORD:-Not found}"
echo "  DB Password: ${DB_PASSWORD:-Not found}"

echo
echo "CRITICAL: All ENV and RUN commands containing"
echo "secrets may remain visible in image history."
echo "Never put secrets in Dockerfiles!"

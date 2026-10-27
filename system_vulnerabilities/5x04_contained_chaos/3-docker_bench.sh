#!/bin/bash
# Run Docker Bench Security against DevStream environment

set -euo pipefail

IMAGE="devstream-vulnerable:latest"
CONTAINER="devstream-bench-test"
BENCH_DIR="${HOME}/docker-bench-security"
REPORT_DIR="$(pwd)/bench-reports"
REPORT="${REPORT_DIR}/docker-bench-results.log"

echo "Running docker-bench-security..."

# Check prerequisites
for cmd in docker git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: $cmd is not installed."
        exit 1
    fi
done

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker daemon is not accessible."
    exit 1
fi

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "ERROR: Image $IMAGE not found."
    echo "Run Task 1 first."
    exit 1
fi

# Download official Docker Bench
if [ ! -d "$BENCH_DIR/.git" ]; then
    echo "Downloading Docker Bench Security..."
    git clone https://github.com/docker/docker-bench-security.git \
        "$BENCH_DIR"
fi

mkdir -p "$REPORT_DIR"

# Remove previous test container
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true

# Start vulnerable container for runtime checks
echo "Starting vulnerable test container..."

docker run -d \
    --name "$CONTAINER" \
    --network none \
    "$IMAGE" >/dev/null

cleanup() {
    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Running CIS Docker Benchmark checks..."

# Run official audit script
cd "$BENCH_DIR"

set +e
sudo bash docker-bench-security.sh -l "$REPORT"
BENCH_STATUS=$?
set -e

echo
echo "Docker Bench exit status: $BENCH_STATUS"

if [ ! -f "$REPORT" ]; then
    echo "ERROR: Audit report was not created."
    exit 1
fi

echo
echo "Container Runtime Checks:"

grep -E '\[(WARN|PASS)\]' "$REPORT" | \
    grep -E '5\.[0-9]+' | head -n 20 || true

echo
echo "Summary:"

for status in PASS WARN INFO NOTE; do
    COUNT=$(grep -c "\[$status\]" "$REPORT" || true)
    echo "  $status: $COUNT"
done

PASS=$(grep -c '\[PASS\]' "$REPORT" || true)
WARN=$(grep -c '\[WARN\]' "$REPORT" || true)

TOTAL=$((PASS + WARN))

if [ "$TOTAL" -gt 0 ]; then
    SCORE=$((PASS * 100 / TOTAL))
else
    SCORE=0
fi

echo "Score: ${SCORE}% (informal PASS/WARN ratio)"
echo "Report saved: $REPORT"

echo
echo "WARNING: Review all findings before deployment."

#!/bin/bash
# Final security audit: vulnerable vs secure Docker containers

set -euo pipefail

VULNERABLE_IMAGE="devstream-vulnerable:latest"
SECURE_IMAGE="secure-python-dev:v1"

VULNERABLE_CONTAINER="devstream-audit-vulnerable"
SECURE_CONTAINER="devstream-audit-secure"

BENCH_DIR="$HOME/docker-bench-security"
REPORT_DIR="audit-reports"

mkdir -p "$REPORT_DIR"

# Check requirements
if [ ! -f "$BENCH_DIR/docker-bench-security.sh" ]; then
    echo "ERROR: docker-bench-security not found."
    echo "Expected: $BENCH_DIR"
    exit 1
fi

for image in "$VULNERABLE_IMAGE" "$SECURE_IMAGE"; do
    if ! docker image inspect "$image" >/dev/null 2>&1; then
        echo "ERROR: Docker image not found: $image"
        exit 1
    fi
done

# Remove test containers when the script exits
cleanup() {
    docker rm -f "$VULNERABLE_CONTAINER" \
        "$SECURE_CONTAINER" >/dev/null 2>&1 || true
}

trap cleanup EXIT

# Run Docker Bench and save its report
run_bench() {
    local report="$1"

    (
        cd "$BENCH_DIR"
        sudo bash ./docker-bench-security.sh
    ) > "$report" 2>&1
}

# Count container image and runtime checks
count_results() {
    local report="$1"
    local status="$2"

    awk -v status="$status" '
        index($0, "[" status "]") > 0 {
            count++
        }
        END {
            print count + 0
        }
    ' "$report"
}

# Calculate percentage
calculate_score() {
    local pass="$1"
    local warn="$2"
    local total=$((pass + warn))

    if [ "$total" -eq 0 ]; then
        echo "N/A"
    else
        echo $((pass * 100 / total))
    fi
}

# Start vulnerable baseline
cleanup

echo "Auditing vulnerable baseline..."

docker run -d \
    --name "$VULNERABLE_CONTAINER" \
    --network none \
    "$VULNERABLE_IMAGE" \
    sleep 300 >/dev/null

run_bench "$REPORT_DIR/vulnerable-bench.log"

V_PASS=$(count_results "$REPORT_DIR/vulnerable-bench.log" PASS)
V_WARN=$(count_results "$REPORT_DIR/vulnerable-bench.log" WARN)
V_SCORE=$(calculate_score "$V_PASS" "$V_WARN")

docker rm -f "$VULNERABLE_CONTAINER" >/dev/null

# Start secure environment
echo "Auditing secure environment..."

docker run -d \
    --name "$SECURE_CONTAINER" \
    --user=devuser \
    --cap-drop=ALL \
    --security-opt=no-new-privileges:true \
    --security-opt=seccomp=builtin \
    --read-only \
    --tmpfs /tmp:rw,nosuid,nodev,size=64m,mode=1777 \
    --memory=256m \
    --memory-swap=256m \
    --cpus=0.5 \
    --pids-limit=50 \
    --network none \
    "$SECURE_IMAGE" \
    sleep 300 >/dev/null

run_bench "$REPORT_DIR/secure-bench.log"

S_PASS=$(count_results "$REPORT_DIR/secure-bench.log" PASS)
S_WARN=$(count_results "$REPORT_DIR/secure-bench.log" WARN)
S_SCORE=$(calculate_score "$S_PASS" "$S_WARN")

echo
echo "Vulnerable Image (devstream-vulnerable):"
echo "  PASS: $V_PASS"
echo "  WARN: $V_WARN"
echo "  Score: $V_SCORE%"

echo
echo "Secure Image (secure-python-dev):"
echo "  PASS: $S_PASS"
echo "  WARN: $S_WARN"
echo "  Score: $S_SCORE%"

echo

if [ "$V_SCORE" != "N/A" ] && [ "$S_SCORE" != "N/A" ]; then
    IMPROVEMENT=$((S_SCORE - V_SCORE))
    printf 'Improvement: %+d percentage points\n' "$IMPROVEMENT"
else
    echo "Improvement: N/A"
fi

echo
echo "Remaining warnings:"

grep '\[WARN\]' "$REPORT_DIR/secure-bench.log" || \
    echo "  No warnings found."

echo
echo "Reports saved in: $REPORT_DIR/"

echo
echo "Audit completed."
echo "Review remaining warnings before production deployment."

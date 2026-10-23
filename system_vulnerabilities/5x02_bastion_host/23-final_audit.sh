#!/bin/bash

set -euo pipefail

echo "=== Final Security Audit ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

if ! command -v lynis >/dev/null 2>&1; then
    echo "ERROR: Lynis is not installed."
    exit 1
fi

REPORT_FILE="/var/log/lynis-report.dat"
LOG_FILE="/var/log/lynis.log"
BASELINE_FILE="/var/log/hardening/baseline-20261020.txt"

if [ $# -ge 1 ]; then
    BASELINE_FILE="$1"
fi

# Preserve the previous report before running a new audit.
if [ -f "$REPORT_FILE" ]; then
    cp "$REPORT_FILE" "${REPORT_FILE}.before-final"
fi

echo "Running Lynis audit..."
echo

if ! lynis audit system --quick --no-colors \
    > /var/log/lynis-final-output.log 2>&1; then
    echo "ERROR: Lynis audit failed."
    tail -30 /var/log/lynis-final-output.log
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    echo "ERROR: Lynis report not found."
    exit 1
fi

# Extract a key=value field from the Lynis report.
get_value() {
    local file="$1"
    local key="$2"

    awk -F= -v key="$key" '
        $1 == key {
            value = $2
        }
        END {
            print value
        }
    ' "$file"
}

# Count warning[] or suggestion[] entries.
count_entries() {
    local file="$1"
    local key="$2"

    awk -v key="$key" '
        index($0, key "[]=") == 1 {
            count++
        }
        END {
            print count+0
        }
    ' "$file"
}

# Display a 20-character progress bar.
make_bar() {
    local score="$1"
    local filled=$((score / 5))
    local empty=$((20 - filled))

    printf "["
    printf '%*s' "$filled" '' | tr ' ' '#'
    printf '%*s' "$empty" '' | tr ' ' '.'
    printf "]"
}

# Read current audit results.
CURRENT_INDEX=$(get_value "$REPORT_FILE" "hardening_index")
CURRENT_TESTS=$(get_value "$REPORT_FILE" "tests_performed")

if ! [[ "$CURRENT_TESTS" =~ ^[0-9]+$ ]]; then
    CURRENT_TESTS=$(get_value "$REPORT_FILE" "tests_executed")
fi

if ! [[ "$CURRENT_TESTS" =~ ^[0-9]+$ ]] &&
   [ -f "$LOG_FILE" ]; then
    CURRENT_TESTS=$(sed -nE \
        's/.*Tests performed:[[:space:]]*([0-9]+).*/\1/p' \
        "$LOG_FILE" | tail -1)
fi

if ! [[ "$CURRENT_TESTS" =~ ^[0-9]+$ ]]; then
    CURRENT_TESTS="Unknown"
fi

CURRENT_WARNINGS=$(count_entries "$REPORT_FILE" "warning")
CURRENT_SUGGESTIONS=$(count_entries "$REPORT_FILE" "suggestion")

if ! [[ "$CURRENT_INDEX" =~ ^[0-9]+$ ]] ||
   [ "$CURRENT_INDEX" -gt 100 ]; then
    echo "ERROR: Invalid hardening index."
    exit 1
fi

echo "Results:"
echo "  Hardening Index: $CURRENT_INDEX $(make_bar "$CURRENT_INDEX")"
echo "  Tests Performed: $CURRENT_TESTS"
echo "  Warnings: $CURRENT_WARNINGS"
echo "  Suggestions: $CURRENT_SUGGESTIONS"
echo

echo "Comparison with baseline:"

BASELINE_VALID=0
INDEX_DIFF=0

if [ -f "$BASELINE_FILE" ]; then

    # Baseline is a custom text report created in Task 0.
    BASE_INDEX=$(awk '/^Hardening Index:/ {print $3}' "$BASELINE_FILE")
    BASE_WARNINGS=$(awk '/^Warnings:/ {print $2}' "$BASELINE_FILE")
    BASE_SUGGESTIONS=$(awk '/^Suggestions:/ {print $2}' "$BASELINE_FILE")

    if [[ "$BASE_INDEX" =~ ^[0-9]+$ ]] &&
       [[ "$BASE_WARNINGS" =~ ^[0-9]+$ ]] &&
       [[ "$BASE_SUGGESTIONS" =~ ^[0-9]+$ ]]; then

        BASELINE_VALID=1

        INDEX_DIFF=$((CURRENT_INDEX - BASE_INDEX))
        WARNING_DIFF=$((BASE_WARNINGS - CURRENT_WARNINGS))
        SUGGESTION_DIFF=$((BASE_SUGGESTIONS - CURRENT_SUGGESTIONS))

        printf "  Hardening Index: %s → %s (%+d points)\n" \
            "$BASE_INDEX" "$CURRENT_INDEX" "$INDEX_DIFF"

        printf "  Warnings: %s → %s (%d fewer)\n" \
            "$BASE_WARNINGS" "$CURRENT_WARNINGS" "$WARNING_DIFF"

        printf "  Suggestions: %s → %s (%d fewer)\n" \
            "$BASE_SUGGESTIONS" "$CURRENT_SUGGESTIONS" "$SUGGESTION_DIFF"

    else
        echo "  ERROR: Invalid baseline data."
    fi
else
    echo "  Baseline not found: $BASELINE_FILE"
    echo "  Comparison unavailable."
fi

echo
echo "Remaining items:"

ITEMS_FOUND=0

while IFS= read -r line; do
    value="${line#warning[]=}"
    echo "  [WARNING] $value"
    ITEMS_FOUND=1
done < <(grep '^warning\[\]=' "$REPORT_FILE" || true)

while IFS= read -r line; do
    value="${line#suggestion[]=}"
    echo "  [SUGGESTION] $value"
    ITEMS_FOUND=1
done < <(grep '^suggestion\[\]=' "$REPORT_FILE" || true)

if [ "$ITEMS_FOUND" -eq 0 ]; then
    echo "  No remaining warnings or suggestions."
fi

echo

if [ "$BASELINE_VALID" -eq 1 ] &&
   [ "$INDEX_DIFF" -gt 0 ]; then
    echo "Summary: System hardening improved."
else
    echo "Summary: Final audit completed."
fi

echo "DMZ deployment requires CISO review."

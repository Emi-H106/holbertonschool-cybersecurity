#!/bin/bash

# APT/DPKG diagnostic script
# No package installation, upgrades, or repairs.

echo "=== APT/DPKG Diagnostic ==="
echo

issues=0

# 1. Check lock files
echo "Lock files:"

locks=(
    /var/lib/dpkg/lock-frontend
    /var/lib/dpkg/lock
    /var/lib/apt/lists/lock
    /var/cache/apt/archives/lock
)

for lock in "${locks[@]}"; do
    if [ -e "$lock" ]; then
        if command -v fuser >/dev/null 2>&1; then
            if fuser "$lock" >/dev/null 2>&1; then
                echo "  $lock: IN USE"
                issues=1
            else
                echo "  $lock: PRESENT (not in use)"
            fi
        else
            echo "  $lock: PRESENT (usage unknown)"
        fi
    else
        echo "  $lock: OK (absent)"
    fi
done

echo

# 2. Check package states
echo "Package states:"

if ! states=$(dpkg-query -W \
    -f='${db:Status-Abbrev} ${Package}\n' 2>/dev/null); then
    echo "  ERROR: Cannot query DPKG database"
    issues=1
    states=""
fi

half_configured=$(printf '%s\n' "$states" |
    awk 'substr($1,2,1)=="F" {print $2}')

half_installed=$(printf '%s\n' "$states" |
    awk 'substr($1,2,1)=="H" {print $2}')

config_files=$(printf '%s\n' "$states" |
    awk 'substr($1,2,1)=="c" {print $2}')

unpacked=$(printf '%s\n' "$states" |
    awk 'substr($1,2,1)=="U" {print $2}')

triggers_pending=$(printf '%s\n' "$states" |
    awk 'substr($1,2,1)=="W" || substr($1,2,1)=="t" {print $2}')

show_packages() {
    local label="$1"
    local packages="$2"
    local count=0

    if [ -n "$packages" ]; then
        count=$(printf '%s\n' "$packages" | wc -l)
    fi

    echo "  $label: $count packages"

    if [ "$count" -gt 0 ]; then
        printf '%s\n' "$packages" | sed 's/^/    - /'
    fi
}

show_packages "Half-configured" "$half_configured"
show_packages "Half-installed" "$half_installed"
show_packages "Config-files" "$config_files"
show_packages "Unpacked" "$unpacked"
show_packages "Triggers pending/awaited" "$triggers_pending"

if [ -n "$half_configured" ] ||
   [ -n "$half_installed" ] ||
   [ -n "$unpacked" ] ||
   [ -n "$triggers_pending" ]; then
    issues=1
fi

echo

# 3. Check APT sources
echo "APT sources:"

valid=0
invalid=0

while IFS= read -r file; do
    [ -f "$file" ] || continue

    case "$file" in
        *.list)
            if grep -Eq '^[[:space:]]*deb(-src)?[[:space:]]' "$file"; then
                valid=$((valid + 1))
            else
                invalid=$((invalid + 1))
                echo "  Check source: $file"
            fi
            ;;
        *.sources)
            if grep -Eq '^[[:space:]]*URIs:' "$file" &&
               grep -Eq '^[[:space:]]*Suites:' "$file"; then
                valid=$((valid + 1))
            else
                invalid=$((invalid + 1))
                echo "  Check source: $file"
            fi
            ;;
    esac
done < <(
    find /etc/apt -maxdepth 2 -type f \
        \( -name '*.list' -o -name '*.sources' \) \
        2>/dev/null
)

echo "  Files with basic valid structure: $valid"
echo "  Files needing review: $invalid"

if [ "$invalid" -gt 0 ]; then
    issues=1
fi

echo "  Checking repository connectivity..."

if [ "$EUID" -ne 0 ]; then
    echo "  Connectivity check skipped: run with sudo"
    issues=1
else
    temp_dir=$(mktemp -d)

    if [ -z "$temp_dir" ] || [ ! -d "$temp_dir" ]; then
        echo "  ERROR: Cannot create temporary directory"
        issues=1
    else
        mkdir -p "$temp_dir/partial"

        apt_output=$(timeout 90 apt-get update \
            -o Dir::State::lists="$temp_dir" \
            -o APT::Update::Error-Mode=any \
            -o Acquire::Retries=0 \
            -o Acquire::http::Timeout=10 \
            -o Acquire::https::Timeout=10 \
            2>&1)
        apt_status=$?

        if [ "$apt_status" -ne 0 ] ||
           printf '%s\n' "$apt_output" |
           grep -Eq '(^Err:|^E:|^W: Failed to fetch|Could not resolve|Temporary failure resolving)'; then
            echo "  Repository connectivity: FAILED"
            printf '%s\n' "$apt_output" |
                grep -E '(^Err:|^E:|^W: Failed to fetch|Could not resolve|Temporary failure resolving)' |
                head -20
            issues=1
        else
            echo "  Repository connectivity: OK"
        fi

        rm -rf -- "$temp_dir"
    fi
fi

echo

# 4. Check interrupted operations
echo "Last APT operation:"

if [ -r /var/log/apt/history.log ]; then
    last_entry=$(awk '
        /^Start-Date:/ {entry=$0; active=1; next}
        /^End-Date:/ {
            if (active) {
                entry=entry "\n" $0
                active=0
            }
        }
        END {
            if (entry != "") print entry
        }
    ' /var/log/apt/history.log)

    if [ -n "$last_entry" ]; then
        printf '%s\n' "$last_entry" | sed 's/^/  /'

        if ! printf '%s\n' "$last_entry" |
            grep -q '^End-Date:'; then
            echo "  Possible interrupted APT operation"
            issues=1
        fi
    else
        echo "  No APT operations found"
    fi
else
    echo "  APT history unavailable"
fi

echo

# 5. Check DPKG database
echo "DPKG database:"

audit_output=$(dpkg --audit 2>&1)
audit_status=$?

if [ "$audit_status" -ne 0 ] || [ -n "$audit_output" ]; then
    echo "  INCONSISTENT or needs review"
    [ -n "$audit_output" ] && printf '%s\n' "$audit_output"
    issues=1
else
    echo "  No problems reported by dpkg --audit"
fi

echo

if [ "$issues" -eq 1 ]; then
    echo "Action required: YES"
else
    echo "Action required: NO (based on completed checks)"
fi

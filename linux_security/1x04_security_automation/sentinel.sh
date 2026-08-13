#!/bin/bash
[ -f sentinel.conf ] || { echo "Error: config file missing" >&2; exit 1; }; source sentinel.conf; declare -p SERVICES >/dev/null 2>&1 && declare -p FILES_TO_WATCH >/dev/null 2>&1 || { echo "Error: required variables missing" >&2; exit 1; }

check_services() {
    for svc in "${SERVICES[@]}"; do
        if pgrep -f "$svc" >/dev/null; then
            echo "OK: $svc is running"
        else
            if eval "$svc"; then
                echo "FIXED: Restarted $svc"
            else
                echo "ERROR: Failed to restart $svc"
            fi
        fi
    done
}
check_services

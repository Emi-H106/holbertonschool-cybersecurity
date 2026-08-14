#!/bin/bash
[ -f sentinel.conf ] || { echo "Error: config file missing" >&2; exit 1; }; source sentinel.conf; declare -p SERVICES >/dev/null 2>&1 && declare -p FILES_TO_WATCH >/dev/null 2>&1 && declare -p ALLOWED_PORTS >/dev/null 2>&1 || { echo "Error: required variables missing" >&2; exit 1; }

log() {
    component="$1"
    target="$2"
    status="$3"
    details="$4"

    timestamp=$(date -u +%FT%TZ)

    echo "{\"timestamp\":\"$timestamp\",\"component\":\"$component\",\"target\":\"$target\",\"status\":\"$status\",\"details\":\"$details\"}" >> /var/log/sentinel.log
}


check_services() {
    for svc in "${SERVICES[@]}"; do
        if pgrep -f "$svc" >/dev/null; then
            log "SERVICE" "$svc" "OK" "Service is running"
        else
            if eval "$svc"; then
                log "SERVICE" "$svc" "FIXED" "Service restarted"
            else
                log "SERVICE" "$svc" "ALERT" "Failed to restart $svc"
            fi
        fi
    done
}


check_integrity() {
    for file in "${FILES_TO_WATCH[@]}"; do
    current_hash=$(md5sum "$file" | awk '{print $1}')

    filename=$(basename "$file")
    golden="/var/backups/sentinel/${filename}.gold"

    golden_hash=$(md5sum "$golden" | awk '{print $1}')

    if [ "$current_hash" = "$golden_hash" ]; then
            log "INTEGRITY" "$file" "OK" "File integrity verified"
        else
            if cp "$golden" "$file"; then
                log "INTEGRITY" "$file" "FIXED" "File restored from backup"
            else
                log "INTEGRITY" "$file" "ALERT" "Failed to restore file"
            fi
        fi
    done
}

check_ports() {
    for port in $(ss -ltn | awk 'NR>1 {print $4}' | awk -F: '{print $NF}'); do
        allowed=false

        for allowed_port in "${ALLOWED_PORTS[@]}"; do
            if [ "$port" = "$allowed_port" ]; then
                allowed=true
                break
            fi
        done

        if [ "$allowed" = false ]; then
            pid=$(netstat -ltnp 2>/dev/null | awk -v p=":$port" '$4 ~ p"$" {split($7,a,"/"); print a[1]}')

            if [ -n "$pid" ]; then
                    if kill "$pid"; then
                        log "PORT" "$port" "ALERT" "Killed rogue process on port $port"
                    else
                        log "PORT" "$port" "ALERT" "Failed to kill rogue process on port $port"
                    fi
            else
                log "PORT" "$port" "ALERT" "Could not find process on port $port"
            fi
        fi
    done
}

check_services
check_integrity
check_ports

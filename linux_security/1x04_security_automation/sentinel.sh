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


check_integrity() {
    for file in "${FILES_TO_WATCH[@]}"; do
    current_hash=$(md5sum "$file" | awk '{print $1}')

    filename=$(basename "$file")
    golden="/var/backups/sentinel/${filename}.gold"

    golden_hash=$(md5sum "$golden" | awk '{print $1}')

    if [ "$current_hash" = "$golden_hash" ]; then
            echo "OK: $file integrity verified"
        else
            cp "$golden" "$file"
            echo "FIXED: Restored $file"
        fi
    done
}
check_integrity

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

            kill "$pid"

            echo "ALERT: Killed rogue process on port $port"
        fi
    done
}
check_ports

        

#!/bin/bash
# NovaTech Hardened Shield
# Service Management Script

set -Eeuo pipefail

log() {
    echo "[INFO] $*"
}

fail() {
    echo "[ERROR] $*" >&2
    exit 1
}

trap 'echo "[ERROR] Failed at line $LINENO" >&2' ERR

readonly WEB_PORT=8080
readonly SSH_PORT=2222

require_root() {
    [[ "$(id -u)" -eq 0 ]] || fail "Root privileges required."
}

start_web() {
    log "Checking Nginx..."

    nginx -t

    if pgrep -x nginx >/dev/null; then
        log "Nginx already running."
    else
        log "Starting Nginx..."
        nginx
    fi
}

start_ssh() {
    log "Checking SSH..."

    mkdir -p /run/sshd
    chmod 755 /run/sshd

    /usr/sbin/sshd -t

    if pgrep -x sshd >/dev/null; then
        log "SSH already running."
    else
        log "Starting SSH..."
        /usr/sbin/sshd
    fi
}

check_web() {
    log "Checking HTTP health..."

    local attempt

    for attempt in 1 2 3 4 5; do
        if curl -fsS --max-time 3 \
            "http://127.0.0.1:${WEB_PORT}/" >/dev/null; then
            log "HTTP health check passed."
            return 0
        fi

        sleep 1
    done

    fail "HTTP health check failed."
}

check_ssh() {
    log "Checking SSH health..."

    local attempt

    for attempt in 1 2 3 4 5; do
        if timeout 3 bash -c \
            "echo > /dev/tcp/127.0.0.1/${SSH_PORT}" \
            2>/dev/null; then
            log "SSH port is reachable."
            return 0
        fi

        sleep 1
    done

    fail "SSH health check failed."
}

main() {
    log "Starting required services..."

    require_root
    start_web
    start_ssh

    check_web
    check_ssh

    log "All required services are healthy."
}

main "$@"
exit 0

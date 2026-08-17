#!/bin/bash

configure_system() {
    export DEBIAN_FRONTEND=noninteractive

    if apt-get update -y && apt-get upgrade -y </dev/null; then
        log "INFO" "System packages updated"
    else
        WARNINGS="Some package updates could not be completed."
        log "WARN" "$WARNINGS"
    fi

    if apt-get remove -y telnet ftp netcat-traditional; then
        log "INFO" "Unwanted packages removed"
    else
        log "WARN" "Some unwanted packages could not be removed"
    fi

    if apt-get install -y auditd fail2ban; then
        log "INFO" "Security tools installed"
    else
        ERRORS="Failed to install one or more security tools."
        log "ERROR" "$ERRORS"
    fi
}

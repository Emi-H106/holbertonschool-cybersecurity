#!/bin/bash

configure_firewall() {
    mkdir -p /etc/hardening

    {
        echo "DEFAULT_INPUT=deny"
        echo "DEFAULT_OUTPUT=allow"
        echo "ALLOW_TCP=$SSH_PORT"

        if [ "$ALLOW_HTTP" = true ]; then
            echo "ALLOW_TCP=80"
        fi

        if [ "$ALLOW_HTTPS" = true ]; then
            echo "ALLOW_TCP=443"
        fi
    } > /etc/hardening/firewall.rules

    log "Firewall policy configured"
}

configure_kernel() {
    sed -i '/^net.ipv4.ip_forward=/d' /etc/sysctl.conf
    sed -i '/^net.ipv4.icmp_echo_ignore_all=/d' /etc/sysctl.conf

    echo "net.ipv4.ip_forward=0" >> /etc/sysctl.conf
    echo "net.ipv4.icmp_echo_ignore_all=1" >> /etc/sysctl.conf

    log "Kernel network settings configured"
}

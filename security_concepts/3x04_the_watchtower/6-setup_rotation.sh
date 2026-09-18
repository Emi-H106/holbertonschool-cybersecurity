#!/bin/bash
set -e
sudo tee /etc/logrotate.d/secure_remote > /dev/null <<'EOF'
/var/log/secure_remote.log {
    daily
    rotate 7
    compress
    missingok
}
EOF
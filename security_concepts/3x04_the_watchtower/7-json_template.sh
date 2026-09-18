#!/bin/bash
sudo tee -a /etc/rsyslog.conf > /dev/null <<'EOF'

template(name="json_fmt" type="string"
    string='{"time":"%timestamp%", "host":"%hostname%", "msg":"%msg%"}\n')
EOF
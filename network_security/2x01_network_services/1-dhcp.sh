#!/bin/bash
nmcli device show | grep 'dhcp_server_identifier' | awk '{print $NF; exit}'

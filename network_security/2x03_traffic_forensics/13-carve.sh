#!/bin/bash
rm -rf /tmp/carved && mkdir -p /tmp/carved && tshark -r "$1" --export-objects http,/tmp/carved >/dev/null 2>&1 && md5sum /tmp/carved/*
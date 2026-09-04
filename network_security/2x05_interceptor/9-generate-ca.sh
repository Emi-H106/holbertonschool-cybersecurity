#!/bin/bash

sudo mkdir -p /etc/squid/ssl_cert
sudo openssl req -x509 -newkey rsa:2048 -keyout /etc/squid/ssl_cert/myCA.pem -out /etc/squid/ssl_cert/myCA.pem -days 365 -nodes -subj "/CN=SquidCA"
sudo /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
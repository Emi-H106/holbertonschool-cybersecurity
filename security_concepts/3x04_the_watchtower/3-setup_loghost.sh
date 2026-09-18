#!/bin/bash

if [ ! -f /etc/rsyslog.conf.bak ]; then
    sudo cp /etc/rsyslog.conf /etc/rsyslog.conf.bak
fi

sudo sed -i 's/^#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf
sudo sed -i 's/^#module(load="imtcp")/module(load="imtcp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imtcp" port="514")/input(type="imtcp" port="514")/' /etc/rsyslog.conf

sudo systemctl restart rsyslog
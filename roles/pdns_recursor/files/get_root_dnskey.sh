#!/bin/bash

i=0
OPENNIC_ROOTNS=""

while [ -z "$OPENNIC_ROOTNS" ]
do
    OPENNIC_ROOTNS=$(curl -sL 'https://api.opennicproject.org/geoip/?bare&res=1')

    ((i++))
    if [[ "$i" == '10' ]]; then
        echo " Failed to get OpenNic RootNS"
        exit 1
    fi
done

dig . DNSKEY @"$OPENNIC_ROOTNS" +noall +answer +additional > /etc/powerdns/OPENNIC.key
cat /usr/share/dns/root.key /etc/powerdns/OPENNIC.key > /etc/powerdns/root.key
chown pdns:pdns /etc/powerdns/root.key


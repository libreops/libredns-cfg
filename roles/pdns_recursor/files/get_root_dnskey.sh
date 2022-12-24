#!/bin/bash

OPENNIC_ROOTNS=""
OPENNIC_ROOTNS=$(curl -sL --retry 10 --retry-delay 5 'https://api.opennicproject.org/geoip/?bare&res=1')

# Exit script if in the end OPENNIC_ROOTNS is empty
if [ -z "$OPENNIC_ROOTNS" ]; then
    echo "Failed to get OpenNic RootNS"
    exit 1
fi

# Get Opennic DNSKEY
dig . DNSKEY @"$OPENNIC_ROOTNS" +nosplit +noall +answer +additional > /etc/powerdns/OPENNIC.key
# Merge Both root NS and Opennic root NS
cat /usr/share/dns/root.key /etc/powerdns/OPENNIC.key > /etc/powerdns/root.key
# Fix file permissions
chown pdns:pdns /etc/powerdns/root.key


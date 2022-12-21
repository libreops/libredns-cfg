#!/bin/bash

OPENNIC_ROOTNS=""
OPENNIC_ROOTNS=$(curl -sL --retry 10 --retry-delay 5 'https://api.opennicproject.org/geoip/?bare&res=1')

# Exit script if in the end OPENNIC_ROOTNS is empty
if [ -z "$OPENNIC_ROOTNS" ]; then
    echo " Failed to get OpenNic RootNS"
    exit 1
fi

# Get Openic root NS
dig . NS @"$OPENNIC_ROOTNS" +noall +answer +additional > /etc/powerdns/root.hints


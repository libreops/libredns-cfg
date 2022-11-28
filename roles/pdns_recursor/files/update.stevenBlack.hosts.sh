#!/bin/bash

# Get StevenBlack hosts
curl -sLo /tmp/hosts.txt https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts

# Get diff
diff -q <(sort -V /etc/powerdns/hosts.txt | column -t) <(sort -V /tmp/hosts.txt | column -t)
DIFF_STATUS=$?

# Get Lines
LINES=`grep -c ^ /tmp/hosts.txt`

# Check & restart if needed
if [ "${LINES}" -gt "200" -a "${DIFF_STATUS}" != "0" ]; then
    cat /etc/powerdns/predator.txt >> /tmp/hosts.txt
    chmod 0644 /tmp/hosts.txt
    chown pdns:pdns /tmp/hosts.txt
    mv -f /tmp/hosts.txt /etc/powerdns/hosts.txt && systemctl restart pdns-recursor-ads
fi

#!/bin/bash

# Get StevenBlack hosts
curl -sLo /tmp/porn-hosts.txt https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts
chmod 0644 /tmp/porn-hosts.txt
chown pdns:pdns /tmp/porn-hosts.txt

# Get diff
diff -q <(sort -V /etc/powerdns/porn-hosts.txt | column -t) <(sort -V /tmp/porn-hosts.txt | column -t)
DIFF_STATUS=$?

# Get Lines
LINES=`grep -c ^ /tmp/porn-hosts.txt`

# Check & restart if needed
if [ "${LINES}" -gt "200" -a "${DIFF_STATUS}" != "0" ]; then
    mv -f /tmp/porn-hosts.txt /etc/powerdns/porn-hosts.txt && systemctl restart pdns-recursor-family
fi
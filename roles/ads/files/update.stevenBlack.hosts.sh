#!/bin/bash

# Get StevenBlack hosts
curl -sLo /tmp/hosts.txt https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
chmod 0644 /tmp/hosts.txt
chown pdns:pdns /tmp/hosts.txt

# Ensure test.libredns.gr is in the hosts.txt
 echo "{{ ansible_default_ipv4.address }} test.libredns.gr" >> /tmp/hosts.txt

# Get diff
diff -q <(sort -V /etc/powerdns/hosts.txt | column -t) <(sort -V /tmp/hosts.txt | column -t)
DIFF_STATUS=$?

# Get Lines
LINES=`grep -c ^ /tmp/hosts.txt`

# Check & restart if needed
if [ "${LINES}" -gt "200" -a "${DIFF_STATUS}" != "0" ]; then
    mv -f /tmp/hosts.txt /etc/powerdns/hosts.txt && systemctl restart pdns-recursor-ads
fi
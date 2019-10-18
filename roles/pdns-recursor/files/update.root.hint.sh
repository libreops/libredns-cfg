#!/bin/bash

# Get OpenNic Tier1 NS
dig . NS @75.127.96.89 | egrep -v '^;|^$' | sort -u -V | column -t > /tmp/root.hint

# Get diff
diff -q <(sort -V /etc/powerdns/root.hints | column -t) /tmp/root.hint
DIFF_STATUS=$?

# Get Lines
LINES=`grep -c ^ /tmp/root.hint`

# Check & restart if needed
if [ "${LINES}" -gt "20" -a "${DIFF_STATUS}" != "0" ]; then
    mv -f /tmp/root.hint /etc/powerdns/root.hints && systemctl restart pdns-recursor
fi

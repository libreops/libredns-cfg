#!/bin/bash
#
# Report TCP connection counts, listen queues and the kernel limits that
# matter for DoT (853, 854) and DoH (443) on libredns.
#
# Persistent kernel settings live in /etc/sysctl.d/99-netfilter.conf,
# managed by Ansible (roles/common/files/99-netfilter.conf).

set -e -u -o pipefail

PORTS=(443 853 854)

# Print a sysctl value, or "n/a" when the key does not exist
# (eg. nf_conntrack keys before the nf_conntrack module is loaded)
get_sysctl() {
    sysctl -n "$1" 2>/dev/null || echo "n/a"
}

# Print one aligned "label : value" row
row() {
    printf '%-27s: %s\n' "$1" "$2"
}

# Count TCP sockets, without the header line
count_tcp() {
    ss -Htn "$@" | wc -l
}

echo ""
row "SYN-RECV sockets" "$(count_tcp state syn-recv)"
for port in "${PORTS[@]}"; do
    # Without -l, ss leaves out the listening socket itself
    row "Connections on ${port}" "$(count_tcp "sport = :${port}")"
done
for port in "${PORTS[@]}"; do
    # For a listening socket, Recv-Q is the accept queue in use and
    # Send-Q is the backlog size (one line per listening address)
    queue=$(ss -Hltn "sport = :${port}" | awk '{ printf "%s%s/%s", sep, $2, $3; sep = " " }')
    row "Listen queue on ${port}" "${queue:-not listening}"
done
echo ""
row "Netfilter conntrack count" "$(get_sysctl net.netfilter.nf_conntrack_count)"
row "Netfilter conntrack max" "$(get_sysctl net.netfilter.nf_conntrack_max)"
row "TCP established timeout" "$(get_sysctl net.netfilter.nf_conntrack_tcp_timeout_established)"
row "TCP max SYN backlog" "$(get_sysctl net.ipv4.tcp_max_syn_backlog)"
row "TCP SYN cookies" "$(get_sysctl net.ipv4.tcp_syncookies)"
row "Socket max connections" "$(get_sysctl net.core.somaxconn)"
echo ""

uptime

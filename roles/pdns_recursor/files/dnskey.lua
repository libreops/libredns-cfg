-- readTrustAnchorsFromFile reads the DNSSEC trust anchors from the provided file
-- and reloads it every 24 hours.
readTrustAnchorsFromFile("/etc/powerdns/root.key")


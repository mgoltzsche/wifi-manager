#!/bin/bash

: ${AP_WIFI_IFACE=wlan0}

set -eu

# Generate create_ap.conf from env vars
cat /etc/create_ap.conf > /tmp/create_ap.conf
set | grep -E '^AP_[A-Z]+=.*' | sed -E 's/^AP_//' >> /tmp/create_ap.conf

# Does not work for some reason!
# Generate nodogsplash (captive portal) configuration from env var
sed -Ei "s!^GatewayInterface .*!GatewayInterface ${AP_WIFI_IFACE}!" /etc/nodogsplash/nodogsplash.conf

# Launch access point
exec create_ap --config /tmp/create_ap.conf --no-virt

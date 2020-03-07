#!/bin/sh

# Debug output
set -x

# Exit on error
set -e

if [ "$1" = 'vpnc-app' ]; then
  shift;
  /firewall.sh
  /firewall6.sh
  exec sg openvpn -c "/usr/sbin/openvpn $@"
fi

exec "$@"

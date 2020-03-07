#!/bin/sh

# Debug output
set -x

# Exit on error
set -e

docker_network="$(ip -o addr show dev eth0 | awk '$3 == "inet" {print $4}')"
if [ -z "$docker_network" ]; then
	>&2 echo "No inet network"
	exit
fi

iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s ${docker_network} -j ACCEPT

iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -d ${docker_network} -j ACCEPT
iptables -A OUTPUT -o tap+ -j ACCEPT
iptables -A OUTPUT -o tun+ -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m owner --gid-owner openvpn -j ACCEPT
iptables -A OUTPUT -p udp -m owner --gid-owner openvpn -j ACCEPT

if [ -n "$NET_LOCAL" ]; then
  iptables -A INPUT -i eth0 -s $NET_LOCAL -j ACCEPT
  iptables -A OUTPUT -o eth0 -d $NET_LOCAL -j ACCEPT
fi

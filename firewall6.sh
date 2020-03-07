#!/bin/sh

# Debug output
set -x

# Exit on error
set -e

docker_network="$(ip -o addr show dev eth0 | awk '$3 == "inet6" {print $4; exit}')"
if [ -z "$docker_network" ]; then
	>&2 echo "No inet6 network"
	exit
fi

ip6tables -F
ip6tables -X
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -s ${docker_network} -j ACCEPT

ip6tables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -A OUTPUT -d ${docker_network} -j ACCEPT
ip6tables -A OUTPUT -o tap+ -j ACCEPT
ip6tables -A OUTPUT -o tun+ -j ACCEPT
ip6tables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp -m owner --gid-owner openvpn -j ACCEPT
ip6tables -A OUTPUT -p udp -m owner --gid-owner openvpn -j ACCEPT

if [ -n "$NET6_LOCAL" ]; then
  ip6tables -A INPUT -i eth0 -s $NET6_LOCAL -j ACCEPT
  ip6tables -A OUTPUT -o eth0 -d $NET6_LOCAL -j ACCEPT
fi

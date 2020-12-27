#!/bin/sh

# Debug output
set -x

# Exit on error
set -e

docker_networks=$(ip link | awk -F': ' '$0 !~ "lo|wg|tun|tap|^[^0-9]"{print $2;getline}' | cut -d@ -f1 | (
  while read interface
  do
    network="$(ip -o addr show dev $interface | awk '$3 == "inet6" {print $4; exit}')"
    if [ -z "$result" ]; then
      result=$network
    else
      result=$result,$network
    fi
  done
  echo $result
))
if [ -z "$docker_networks" ]; then
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
ip6tables -A INPUT -s ${docker_networks} -j ACCEPT

ip6tables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -A OUTPUT -d ${docker_networks} -j ACCEPT
ip6tables -A OUTPUT -o tap+ -j ACCEPT
ip6tables -A OUTPUT -o tun+ -j ACCEPT
ip6tables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp -m owner --gid-owner $APP_GROUPNAME -j ACCEPT
ip6tables -A OUTPUT -p udp -m owner --gid-owner $APP_GROUPNAME -j ACCEPT

ip6tables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A FORWARD -i lo -j ACCEPT
ip6tables -A FORWARD -d ${docker_networks} -j ACCEPT
ip6tables -A FORWARD -s ${docker_networks} -j ACCEPT

ip6tables -t nat -A POSTROUTING -o wg+ -j MASQUERADE

if [ -n "$NET6_LOCAL" ]; then
  ip6tables -A INPUT -i eth0 -s $NET6_LOCAL -j ACCEPT
  ip6tables -A OUTPUT -o eth0 -d $NET6_LOCAL -j ACCEPT
fi

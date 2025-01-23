#!/usr/bin/env bash
#
# block-private-ranges.sh
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/meph/hetzner-block-private-ranges/main/block-private-ranges.sh | sudo bash
#
# Description:
#   Determines the default network interface and adds iptables rules to block
#   outbound UDP traffic to various private and reserved IP address ranges.

set -euo pipefail

# Identify the default (public) interface
publiciface=$(ip route show default | awk '/default/ {print $5}')

# Safety check
if [ -z "$publiciface" ]; then
  echo "ERROR: Could not determine the default interface."
  exit 1
fi

echo "Using public interface: $publiciface"

# The iptables rules (DROP outbound UDP to reserved ranges on the default interface)
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 0.0.0.0/8 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 10.0.0.0/8 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 100.64.0.0/10 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 169.254.0.0/16 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 172.16.0.0/12 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 192.0.0.0/24 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 192.0.2.0/24 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 192.88.99.0/24 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 192.168.0.0/16 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 198.18.0.0/15 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 198.51.100.0/24 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 203.0.113.0/24 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 224.0.0.0/4 -j DROP
iptables -A OUTPUT -o "$publiciface" -p udp -s 0/0 -d 240.0.0.0/4 -j DROP

echo "All rules have been applied to $publiciface."
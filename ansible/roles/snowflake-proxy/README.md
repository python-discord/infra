# snowflake-proxy

This Ansible role installs and enables a
[Snowflake](https://snowflake.torproject.org/) proxy.

Snowflake is a system that helps people circumvent censorship by acting as an
unknown middle layer between the publically known Tor network relay addresses
and the user behind a censoring firewall. More specifically, we act as a
forwarding proxy to the Tor network for the user, passing along encrypted
traffic and allowing users to access an uncensored internet without firewalls
having our IP on any public list that they can ban us from.

Naturally this system works best from dynamic IP addresses.

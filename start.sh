#!/bin/sh

(/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock > /tmp/tailscaled.log 2>&1 &)
/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=example-name-tss5
/app/tailscale-socks5 -p :1080
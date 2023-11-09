#!/bin/sh

(/app/tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socks5-server=localhost:1081 > /tmp/tailscaled.log 2>&1 &)
/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=tailscale-socks5
echo "expose :0.0.0.0:1080 <-> tailscale listen on :1081"
/app/tailscale-socks5 -l 127.0.0.1:1081 -r 0.0.0.0:1080
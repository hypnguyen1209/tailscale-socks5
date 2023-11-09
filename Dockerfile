FROM golang:alpine as builder

WORKDIR /app
COPY main.go .
COPY go.mod .
RUN go build

FROM alpine:latest
ENV TAILSCALE_AUTHKEY="fill me"
ENV TS_USERSPACE=true
ENV TS_TAILSCALED_EXTRA_ARGS='--tun=userspace-networking'
ENV TS_OUTBOUND_HTTP_PROXY_LISTEN=true
RUN apk update && apk add curl ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*
WORKDIR /app
COPY --from=builder /app/tailscale-socks5 /app/tailscale-socks5
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale
COPY start.sh /app
RUN chmod +x /app/start.sh
EXPOSE 1080
CMD /app/start.sh

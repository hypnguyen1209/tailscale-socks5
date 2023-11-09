FROM golang:alpine as builder

WORKDIR /app
COPY main.go .
COPY go.mod .
COPY go.sum .
RUN go mod download
RUN go build

FROM alpine:latest
ENV TAILSCALE_AUTHKEY="fill me"
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*
WORKDIR /app
COPY --from=builder /app/tailscale-socks5 /app/tailscale-socks5
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale
COPY start.sh /app
RUN chmod +x /app/start.sh
EXPOSE 1080
CMD /app/start.sh

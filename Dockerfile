FROM certbot/dns-route53:latest@sha256:b058873642348ec79142d1ff7a84af8918027ed92b45b8a1f09222e143c2a094

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install minimal tools and do not store caches
RUN apk add --no-cache --update --verbose socat bash tini

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/renew"]

FROM certbot/dns-route53@sha256:e2b2f7a803b8673ca09dd3d856299a89ec888caaddce4f984d1bde3254bf21c7

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install minimal tools and do not store caches
RUN apk add --no-cache --update --verbose socat bash tini

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/renew"]

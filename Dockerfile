FROM docker.io/certbot/dns-route53@sha256:85655cdf29adfdd58f871c19b5b8bc3a182c70eaa670b7cdde92da72052a4486 AS base

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install minimal tools and do not store caches
RUN apk add --no-cache --update --verbose socat bash tini

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/renew"]

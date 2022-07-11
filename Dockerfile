FROM certbot/dns-route53:latest@sha256:661c8470a33711e268730bb58c83de76c97389c132f722f23852e0f268e42dd3

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install minimal tools and do not store caches
RUN apk add --no-cache --update --verbose socat bash tini

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/renew"]

FROM certbot/dns-route53:latest@sha256:b6c66ddc88f481a53feec06e493fc1dbc95adcee7ef3a4bcba99d893ceabd7e4

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install minimal tools and do not store caches
RUN apk add --no-cache --update --verbose socat bash tini

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/renew"]

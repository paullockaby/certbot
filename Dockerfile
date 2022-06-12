FROM certbot/dns-route53:latest@sha256:39c989cab7a44f996fc4a7675b53c34ce245203e1f26220c07d54cbdad1d3849

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install minimal tools and do not store caches
RUN apk add --no-cache --update --verbose socat bash tini

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/renew"]

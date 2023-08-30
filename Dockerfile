FROM debian:bookworm-slim@sha256:741bae561f5c2261f4cdd535e4fd4c248dec0aafc1b9a1410b3d67ad24571340 AS base

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends tini socat certbot python3-certbot-dns-route53 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/lib/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/renew"]

FROM debian:bullseye-slim@sha256:e8ad0bc7d0ee6afd46e904780942033ab83b42b446b58efa88d31ecf3adf4678 AS base

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

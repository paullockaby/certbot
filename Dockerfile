FROM python:3.9.12-slim-bullseye@sha256:b855d669da5b39e896557608eeeb5b285399bf99e7fb321f868b59bae30da37c AS base

# github metadata
LABEL org.opencontainers.image.source=https://github.com/paullockaby/certbot

# install updates and dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends tini && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

FROM base AS builder

# install python dependencies
COPY requirements.txt /
RUN python3 -m venv --system-site-packages /opt/certbot && \
    . /opt/certbot/bin/activate && \
    pip3 install --no-cache-dir -r /requirements.txt

FROM base AS final

# packages needed to run this thing
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && \
    apt-get install -y --no-install-recommends openssh-client rsync socat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# copy the virtual environment that we just built
COPY --from=builder /opt /opt

# copy the script for interacting with certbot
COPY certbot /usr/local/bin/certbot
RUN chmod +x /usr/local/bin/certbot

# install the entrypoint last to help with caching
COPY renew /usr/local/bin/renew
RUN chmod +x /usr/local/bin/renew

VOLUME ["/etc/letsencrypt", "/var/log/letsencrypt"]
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/renew"]

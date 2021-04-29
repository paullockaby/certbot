FROM python:3.9.4-slim-buster@sha256:bca2bcc8afda3abca3f73ff3d9ac146076aa47d09a226290eb3c99f175b1371a AS base

# github metadata
LABEL org.opencontainers.image.source https://github.com/paullockaby/certbot

FROM base AS builder

# install python dependencies
COPY requirements.txt /
RUN python3 -m venv --system-site-packages /opt/certbot && \
    . /opt/certbot/bin/activate && \
    pip3 install --no-cache-dir -r /requirements.txt

FROM base AS final

# packages needed to run this thing
# packages needed to run this thing
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && \
    apt-get install -y --no-install-recommends tini openssh-client rsync socat && \
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
CMD ["bash"]
#CMD ["/usr/bin/tini", "--", "/usr/local/bin/certbot"]

FROM debian:bookworm AS base

ENV ELOQ_PACKAGE=b0830
ENV ELOQ_VERSION=8.3

# Specifying handy vars
ENV ELOQ_CFG="/etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg"
ENV ELOQ_DIR=/var/lib/eloquence
ENV ELOQ_DATA_DIR="$ELOQ_DIR/data"
ENV ELOQ_USER=eloqdb

# Add Eloquence's bin to the path
ENV PATH="$PATH:/opt/eloquence/$ELOQ_VERSION/bin"

# Add Eloquence Debian repository
RUN apt update && \
    apt install -y wget openssl && \
    cd /etc/apt/sources.list.d && \
    wget https://marxmeier.com/download/repo/deb/eloquence.list && \
    wget -O /etc/apt/trusted.gpg.d/eloquence.asc \
        https://marxmeier.com/download/repo/deb/signing.key && \
    apt update

# Install Eloquence
RUN apt install -y eloquence.${ELOQ_PACKAGE}

# Create user
RUN useradd $ELOQ_USER -s /bin/bash

USER eloqdb

# Create directories and set permissions
RUN mkdir -p $ELOQ_DATA_DIR && \
    mkdir -p $ELOQ_LOGS_DIR && \
    mkdir /docker-entrypoint.d

# Send log messages to Docker
RUN ln -sf /dev/stdout /var/logs/eloquence.log

COPY files/eloqdb.cfg $ELOQ_CFG
COPY --chmod=755 entrypoint/docker-entrypoint.sh /

EXPOSE 8102

VOLUME "$ELOQ_DATA_DIR"

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["eloqdb" "-f"]
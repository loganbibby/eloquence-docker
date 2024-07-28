FROM debian:bookworm AS base

ENV ELOQ_PACKAGE=b0830
ENV ELOQ_VERSION=8.3

# Specifying handy vars
ENV ELOQ_DIR=/var/lib/eloquence
ENV ELOQ_CFG="$ELOQ_DIR/eloqdb.cfg"
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
RUN apt install -y eloquence.${ELOQ_PACKAGE} && \
    cp /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg.orig

# Create user
RUN useradd $ELOQ_USER -s /bin/bash

RUN mkdir -p $ELOQ_DATA_DIR && \
    mkdir -p $(dirname -- "$ELOQ_CFG") && \
    chown -R $ELOQ_USER:$ELOQ_USER $ELOQ_DIR && \
    mkdir -p /docker-entrypoint.d && \
    chown $ELOQ_USER:$ELOQ_USER /docker-entrypoint.d

# Send log messages to Docker
RUN ln -sf /dev/stdout /var/log/eloquence.log

# Make synlink to config file so -c doesn't need to be used
RUN touch $ELOQ_CFG && \
    ln -sf $ELOQ_CFG /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg && \
    chown $ELOQ_USER:$ELOQ_USER /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg

USER eloqdb

COPY --chmod=755 entrypoint/docker-entrypoint.sh /
COPY --chmod=755 entrypoint/00-create-cfg-file.sh /docker-entrypoint.d
COPY --chmod=755 entrypoint/01-create-root-volume.sh /docker-entrypoint.d

EXPOSE 8102

VOLUME $ELOQ_DIR

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["eloqdb", "-f"]
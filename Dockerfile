FROM debian:bookworm AS base

VOLUME /var/opt/eloquence/db/
EXPOSE 8102

ENV ELOQ_PACKAGE=b0830
ENV ELOQ_VERSION=8.3

# Specifying handy vars
ENV ELOQ_DATA_DIR=/var/opt/eloquence/db
ENV ELOQ_USER=eloqdb

# Add Eloquence's bin to the path
ENV PATH="$PATH:/opt/eloquence/$ELOQ_VERSION/bin"

# Create user
RUN useradd $ELOQ_USER -s /bin/bash

# Add Eloquence Debian repository
RUN apt update && \
    apt install -y wget openssl nano && \
    cd /etc/apt/sources.list.d && \
    wget https://marxmeier.com/download/repo/deb/eloquence.list && \
    wget -O /etc/apt/trusted.gpg.d/eloquence.asc \
        https://marxmeier.com/download/repo/deb/signing.key && \
    apt update

# Install Eloquence
RUN apt install -y eloquence.${ELOQ_PACKAGE}


RUN mkdir -p /docker-entrypoint.d && \
    chown $ELOQ_USER:$ELOQ_USER /docker-entrypoint.d && \
    chown -R $ELOQ_USER:$ELOQ_USER /etc/opt/eloquence/$ELOQ_VERSION && \
    mkdir -p ${ELOQ_DATA_DIR} && \
    chown $ELOQ_USER:$ELOQ_USER ${ELOQ_DATA_DIR}

# Copy configuration file
COPY --chmod=755 ./docker/files/eloqdb.cfg /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg
RUN chown $ELOQ_USER:$ELOQ_USER /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg

# Copy entrypoint files
COPY --chmod=755 ./docker/docker-entrypoint.d /docker-entrypoint.d
RUN chown -R $ELOQ_USER:$ELOQ_USER /docker-entrypoint.d/

# Copy entrypoint
COPY --chmod=755 ./docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chown $ELOQ_USER:$ELOQ_USER /docker-entrypoint.sh

USER eloqdb

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["eloqdb", "-f"]
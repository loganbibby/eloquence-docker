FROM debian:bookworm AS base

ENV ELOQ_PACKAGE=b0830
ENV ELOQ_VERSION=8.3

# Specifying handy vars
ENV ELOQ_DATA_DIR=/var/opt/eloquence/db
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

RUN mkdir -p /docker-entrypoint.d && \
    chown $ELOQ_USER:$ELOQ_USER /docker-entrypoint.d && \
    chown -R $ELOQ_USER:$ELOQ_USER /etc/opt/eloquence/$ELOQ_VERSION && \
    mkdir -p ${ELOQ_DATA_DIR} && \
    chown $ELOQ_USER:$ELOQ_USER ${ELOQ_DATA_DIR}

# Copy configuration file
COPY ./docker/files/eloqdb.cfg /etc/eloquence/$ELOQ_VERSION/eloqdb.cfg

USER eloqdb

COPY --chmod=755 /docker /

EXPOSE 8102

VOLUME /var/opt/eloquence/db/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["eloqdb", "-f"]
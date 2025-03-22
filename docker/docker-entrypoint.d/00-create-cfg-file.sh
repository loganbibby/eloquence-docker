#!/bin/bash

if [ ! -s $ELOQ_CFG ]; then
    cp /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg.orig $ELOQ_CFG
    echo "[db-access]" >> $ELOQ_CFG
    echo "allow = all" >> $ELOQ_CFG
    exit 0
fi

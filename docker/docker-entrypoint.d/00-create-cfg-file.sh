#!/bin/bash

if [ ! -s $ELOQ_CFG ]; then
    cp /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg.orig $ELOQ_CFG
    exit 0
fi

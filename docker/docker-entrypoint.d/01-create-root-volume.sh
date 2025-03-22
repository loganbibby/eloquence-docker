#!/bin/bash

if [[ ! -f "$ELOQ_DATA_DIR/VOLUME01.VOL" ]]; then
    dbvolcreate -c /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg $ELOQ_DATA_DIR/VOLUME01.VOL
    dbvolextend -c /etc/opt/eloquence/$ELOQ_VERSION/eloqdb.cfg -t log $ELOQ_DATA_DIR/VOLUME02.VOL
fi
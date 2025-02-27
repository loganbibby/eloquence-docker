#!/bin/bash

if [[ ! -f "$ELOQ_DATA_DIR/VOLUME01.VOL" ]]; then
    dbvolcreate $ELOQ_DATA_DIR/VOLUME01.VOL
    dbvolextend -t log $ELOQ_DATA_DIR/VOLUME02.VOL
fi
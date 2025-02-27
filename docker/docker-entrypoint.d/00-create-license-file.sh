#!/bin/bash

if [ ! -z $ELOQ_LICENSE ]; then
    LICENSE_FILE=/etc/opt/eloquence/$ELOQ_VERSION/license
    CURRENT_LICENSE=$(cat $LICENSE_FILE)

    DECODED_LICENSE=$(echo $ELOQ_LICENSE | base64 -d)
    echo "${DECODED_LICENSE}" > $LICENSE_FILE
    
    LICENSE_CHECK=$(/opt/eloquence/$ELOQ_VERSION/etc/chklic)

    if [[ $(echo "$LICENSE_CHECK" | grep "** Failed **" -c) = 0 ]]; then
        echo "License check passed. Good to go!"
    else
        echo "License check failed. Reverting to previous license."
        echo "Command output: ${LICENSE_CHECK}"
        echo "${CURRENT_LICENSE}" > $LICENSE_FILE
    fi
else
    echo "Eloquence license was empty"
fi

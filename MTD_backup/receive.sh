#!/bin/bash

LISTEN_PORT=9999

while true; do
    # Get filename
    FILENAME=$(nc -l -p $LISTEN_PORT)
    if [ -z "$FILENAME" ]; then
        break
    fi
    echo "Receiving $FILENAME..."
    # Get file content
    nc -l -p $LISTEN_PORT > "$FILENAME"
done


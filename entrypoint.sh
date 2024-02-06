#!/bin/sh

# Check if the SALT environment variable is empty
if [ -z "$SALT" ]; then
    SALT=$(openssl rand -hex 16)
    export SALT
fi

# Start the Go application with the SALT value
exec /usr/local/bin/main -salt="$SALT"

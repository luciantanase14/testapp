#!/bin/sh

# Check if the SALT environment variable is empty
if [ -z "$SALT" ]; then
    echo "No SALT provided. Generating a random SALT."
    SALT=$(openssl rand -hex 16)
    export SALT
    # Removed the line that logs the generated SALT to improve security
fi

# Start the Go application with the SALT value
exec /usr/local/bin/main -salt="$SALT"

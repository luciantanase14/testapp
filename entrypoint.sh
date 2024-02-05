#!/bin/sh
# entrypoint.sh

# Checking if the app_salt secret exists and read it
if [ -f /run/secrets/app_salt ]; then
    export SALT=$(cat /run/secrets/app_salt)
else
    echo "Warning: /run/secrets/app_salt not found. Using default or environment-provided SALT value."
fi

# Execute the main container command
exec "$@"

#!/bin/sh
# entrypoint.sh

# Read the secret
export SALT=$(cat /run/secrets/app_salt)

# Execute the main container command
exec "$@"

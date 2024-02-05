#!/bin/sh
# entrypoint.sh

# Check if the app_salt secret exists and use it if present:
if [ -f /run/secrets/app_salt ]; then
    export SALT=$(cat /run/secrets/app_salt)
# Check if SALT is already set as an environment variable:
elif [ -z "${SALT}" ]; then
    # Generate a secure SALT value if not provided:
    export SALT=$(openssl rand -hex 16)
    # Redirect the output of the echo command to /dev/null to suppress it:
    echo "Generated a new SALT value" >/dev/null
fi

# Execute the main container command
exec "$@"

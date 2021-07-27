#!/bin/bash

set -o errexit
set -o nounset

export LISTEN_PORT="${LISTEN_PORT:-8081}"
export GALAXY_API_HOST="${GALAXY_API_HOST:-galaxy-api}"
export GALAXY_API_PORT="${GALAXY_API_PORT:-5001}"

envsubst '${LISTEN_PORT},${GALAXY_API_HOST},${GALAXY_API_PORT}' \
    < "${NGINX_CONFIGURATION_PATH}/default.conf" \
    > /tmp/output.conf
cp /tmp/output.conf "${NGINX_CONFIGURATION_PATH}/default.conf"

exec nginx -g "daemon off;"

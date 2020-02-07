#!/bin/bash

# NOTE: This line should be before setting bash modes, because
# `scl_source` is not compatible with `set -o nounset`.
ENABLED_COLLECTIONS="${ENABLED_COLLECTIONS:-}"
if [[ ! -z "${ENABLED_COLLECTIONS}" ]]; then
  source scl_source enable ${ENABLED_COLLECTIONS}
fi
export PATH="${PULP_VENV}/bin:$PATH"


set -o nounset
set -o errexit


PULP_CODE="${PULP_CODE}"


_wait_for_tcp_port() {
  local -r host="$1"
  local -r port="$2"

  local attempts=6
  local timeout=1

  echo "[debug]: Waiting for port tcp://${host}:${port}"
  while [ $attempts -gt 0 ]; do
    timeout 1 /bin/bash -c ">/dev/tcp/${host}/${port}" &>/dev/null && return 0 || :

    echo "[debug]: Waiting ${timeout} seconds more..."
    sleep $timeout

    timeout=$(( $timeout * 2 ))
    attempts=$(( $attempts - 1 ))
  done

  echo "[error]: Port tcp://${host}:${port} is not available"
  return 1
}

_prepare_env() {
  _wait_for_tcp_port "${PULP_DB_HOST:-postgres}" "${PULP_DB_PORT:-5432}"
  _wait_for_tcp_port "${PULP_REDIS_HOST:-redis}" "${PULP_REDIS_PORT:-6379}"
  django-admin migrate
}

run_service() {
  case "$1" in
    'api')
      run_api
      ;;
    'resource-manager')
      run_resource_manager
      ;;
    'worker')
      run_worker
      ;;
    'content-app')
      run_content_app
      ;;
    *)
      echo 'Invalid command'
      exit 1
  esac
}

run_api() {
  _prepare_env
  exec uwsgi \
      --master \
      --http-socket :8000 \
      --module 'pulpcore.app.wsgi:application' \
      --threads 4 \
      --buffer-size 32768
}

run_resource_manager() {
  _prepare_env
  # FIXME(cutwater): This is temporary fix for pulp
  #   incorrectly handling worker process termination.
  #   It makes impossible running multiple instances of worker.
  # exec rq worker \
  #     -w 'pulpcore.tasking.worker.PulpWorker' \
  #     -n 'resource-manager@%h' \
  #     -c 'pulpcore.rqconfig'
  exec rq worker \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -c 'pulpcore.rqconfig' \
      -n 'resource-manager'
}

run_worker() {
  _prepare_env
  # FIXME(cutwater): This is temporary fix for pulp
  #   incorrectly handling worker process termination.
  #   It makes impossible running multiple instances of worker.
  # exec rq worker \
  #     -w 'pulpcore.tasking.worker.PulpWorker' \
  #     -n "reserved-resource-worker@%h" \
  #     -c 'pulpcore.rqconfig'
  exec rq worker \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -c 'pulpcore.rqconfig' \
      -n "worker@automation-hub"
}

run_content_app() {
  _prepare_env
  exec pulp-content
}

manage() {
  exec django-admin "$@"
}

main() {
  case "$1" in
    'run')
      run_service "${@:2}"
      ;;
    'manage')
      manage "${@:2}"
      ;;
    *)
      exec "$@"
      ;;
    esac
}

main "$@"

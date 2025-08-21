#!/usr/bin/env bash
set -euo pipefail

export CHATGPT_LOCAL_HOME="${CHATGPT_LOCAL_HOME:-/data}"

cmd="${1:-serve}"
shift || true

bool() {
  case "${1:-}" in
    1|true|TRUE|yes|YES|on|ON) return 0;;
    *) return 1;;
  esac
}

if [[ "$cmd" == "serve" ]]; then
  PORT="${PORT:-8000}"

  # Gunicorn production server
  exec gunicorn -w 4 -b 0.0.0.0:${PORT} 'chatmock.app:create_app()'
elif [[ "$cmd" == "login" ]]; then
  ARGS=(login --no-browser)
  if bool "${VERBOSE:-}" || bool "${CHATGPT_LOCAL_VERBOSE:-}"; then
    ARGS+=(--verbose)
  fi

  exec python chatmock.py "${ARGS[@]}"
else
  exec "$cmd" "$@"
fi


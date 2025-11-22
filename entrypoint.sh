#!/usr/bin/env bash
set -euo pipefail

if [ -d /app ]; then
  cd /app
fi

exec "$@"

#!/usr/bin/env bash
set -euo pipefail

DB_CONT="myapp-db"
WEB_CONT="myapp-web-1"

echo "[stop] Stopping containers (state preserved in named volume)..."
docker stop "$WEB_CONT" >/dev/null 2>&1 || true
docker stop "$DB_CONT"  >/dev/null 2>&1 || true
echo "[stop] Done."

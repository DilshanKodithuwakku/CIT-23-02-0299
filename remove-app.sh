#!/usr/bin/env bash
set -euo pipefail

APP_NET="myapp-net"
PG_VOL="myapp-pgdata"
WEB_IMG="myapp-web"
DB_CONT="myapp-db"
WEB_CONT="myapp-web-1"

echo "[remove] Removing containers..."
docker rm -f "$WEB_CONT" >/dev/null 2>&1 || true
docker rm -f "$DB_CONT"  >/dev/null 2>&1 || true

echo "[remove] Removing image..."
docker rmi "$WEB_IMG" >/dev/null 2>&1 || true

echo "[remove] Removing network..."
docker network rm "$APP_NET" >/dev/null 2>&1 || true

echo "[remove] Removing volume (this will delete persistent DB data!)..."
docker volume rm "$PG_VOL" >/dev/null 2>&1 || true

echo "[remove] Done."

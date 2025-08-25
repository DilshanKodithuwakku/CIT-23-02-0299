#!/usr/bin/env bash
set -euo pipefail

APP_NET="myapp-net"
PG_VOL="myapp-pgdata"
WEB_IMG="myapp-web"

echo "[prepare] Building web image..."
docker build -t "$WEB_IMG" -f web/Dockerfile web

echo "[prepare] Creating network (if not exists)..."
docker network inspect "$APP_NET" >/dev/null 2>&1 || docker network create "$APP_NET"

echo "[prepare] Creating named volume for Postgres data (if not exists)..."
docker volume inspect "$PG_VOL" >/dev/null 2>&1 || docker volume create "$PG_VOL"

echo "[prepare] Done."

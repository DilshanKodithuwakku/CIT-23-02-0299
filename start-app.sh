#!/usr/bin/env bash
set -euo pipefail

APP_NET="myapp-net"
PG_VOL="myapp-pgdata"
WEB_IMG="myapp-web"

DB_CONT="myapp-db"
WEB_CONT="myapp-web-1"

# Configuration
DB_USER="appuser"
DB_PASSWORD="apppass"
DB_NAME="appdb"
DB_PORT=5432
WEB_PORT=5000

echo "[start] Starting database..."
# Note: no host port published for DB; it listens on 5432 inside the network.
docker rm -f "$DB_CONT" >/dev/null 2>&1 || true
docker run -d \
  --name "$DB_CONT" \
  --network "$APP_NET" \
  -e POSTGRES_USER="$DB_USER" \
  -e POSTGRES_PASSWORD="$DB_PASSWORD" \
  -e POSTGRES_DB="$DB_NAME" \
  -v "$PG_VOL:/var/lib/postgresql/data" \
  --restart on-failure:5 \
  postgres:16-alpine

echo "[start] Starting web app..."
docker rm -f "$WEB_CONT" >/dev/null 2>&1 || true
docker run -d \
  --name "$WEB_CONT" \
  --network "$APP_NET" \
  -p "$WEB_PORT:5000" \
  -e DB_HOST="$DB_CONT" \
  -e DB_PORT="$DB_PORT" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e DB_NAME="$DB_NAME" \
  --restart on-failure:5 \
  "$WEB_IMG"

echo "The app is available at http://localhost:${WEB_PORT}"

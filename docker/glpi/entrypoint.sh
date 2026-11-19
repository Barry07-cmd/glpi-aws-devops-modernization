#!/bin/bash
set -eu

echo "[entrypoint] Waiting for database at ${DB_HOST}:${DB_PORT}..."
for i in $(seq 1 30); do
  if (echo > "/dev/tcp/${DB_HOST}/${DB_PORT}") 2>/dev/null; then
    echo "[entrypoint] Database is reachable."
    break
  fi
  if [ "$i" -eq 30 ]; then
    echo "[entrypoint] ERROR: database not reachable after 30 attempts." >&2
    exit 1
  fi
  sleep 2
done

CONFIG_FILE="/var/www/glpi/config/config_db.php"

if [ -f "$CONFIG_FILE" ]; then
  echo "[entrypoint] GLPI already installed, skipping install."
else
  echo "[entrypoint] First start: installing GLPI..."
  php /var/www/glpi/bin/console database:install \
    --db-host="${DB_HOST}" \
    --db-port="${DB_PORT}" \
    --db-name="${DB_NAME}" \
    --db-user="${DB_USER}" \
    --db-password="${DB_PASSWORD}" \
    --no-interaction \
    --no-telemetry
  echo "[entrypoint] Install finished."
fi

exec docker-php-entrypoint "$@"

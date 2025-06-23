#!/usr/bin/env bash
set -e

# Mount Cloud Storage bucket if provided
if [[ -n "$GCS_BUCKET" ]]; then
  mkdir -p /gcs
  gcsfuse "$GCS_BUCKET" /gcs
  mkdir -p /gcs/backups
fi

# Run database setup
bundle exec rake db:create db:migrate

# Optionally backup database on start
if [[ "$BACKUP_ON_START" == "true" && -n "$GCS_BUCKET" ]]; then
  ts=$(date +%Y%m%d%H%M%S)
  if [[ "$DATABASE_URL" == postgres* ]]; then
    pg_dump "$DATABASE_URL" > "/gcs/backups/backup_$ts.sql"
  else
    sqlite3 db/app.sqlite3 ".backup '/gcs/backups/backup_$ts.sqlite3'"
  fi
fi

exec bundle exec rackup -o 0.0.0.0 -p "${PORT:-8080}"

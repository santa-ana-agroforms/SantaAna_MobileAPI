#!/bin/sh
set -eu

HOST="api"
PORT="3000"
TRIES=120

echo "Esperando a ${HOST}:${PORT} ..."
i=0
while ! nc -z "${HOST}" "${PORT}" >/dev/null 2>&1; do
  i=$((i+1))
  if [ "$i" -ge "$TRIES" ]; then
    echo "Timeout esperando ${HOST}:${PORT}"
    exit 1
  fi
  sleep 1
done

echo "API lista, lanzando Locust..."
exec locust \
  -f /mnt/locust/locustfile.py \
  --host http://api:3000 \
  --headless -u 30 -r 3 -t 5m --only-summary \
  --html /mnt/locust/reports/locust.html \
  --csv  /mnt/locust/reports/locust

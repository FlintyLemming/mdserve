#!/bin/sh
set -eu

if [ "$#" -lt 1 ]; then
  echo "Usage: docker run -p 8080:8080 -v /path/file.md:/data/file.md IMAGE /data/file.md" >&2
  exit 1
fi

file="$1"
shift

if [ ! -f "$file" ]; then
  echo "Markdown file not found: $file" >&2
  exit 1
fi

port="${MDSERVE_PORT:-8080}"
host="${MDSERVE_HOST:-0.0.0.0}"

exec /usr/local/bin/mdserve "$file" --hostname "$host" --port "$port" "$@"

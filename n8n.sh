#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [[ -f .env ]]; then
  set -a
  source .env
  set +a
elif [[ -f .env.example ]]; then
  echo "[n8n.sh] .env not found; using values from .env.example"
  set -a
  source .env.example
  set +a
else
  echo "[n8n.sh] missing .env and .env.example" >&2
  exit 1
fi

cmd="${1:-help}"
shift || true

case "$cmd" in
  up)
    docker compose up -d "$@"
    ;;
  down)
    docker compose down "$@"
    ;;
  logs)
    docker compose logs -f --tail=200 "$@"
    ;;
  ps)
    docker compose ps "$@"
    ;;
  pull)
    docker compose pull "$@"
    ;;
  restart)
    docker compose restart "$@"
    ;;
  config)
    docker compose config "$@"
    ;;
  *)
    cat <<'USAGE'
Usage: ./n8n.sh <command>

Commands:
  up        Start stack in background
  down      Stop and remove stack
  logs      Tail logs
  ps        Show service status
  pull      Pull latest images
  restart   Restart services
  config    Render merged compose config
USAGE
    ;;
esac

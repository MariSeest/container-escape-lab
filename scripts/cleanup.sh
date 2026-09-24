#!/usr/bin/env bash
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
docker compose -f "$HERE/environment/docker-compose.yml" down --rmi local -v || true
docker run --rm -v /:/host alpine:latest sh -c 'rm -f /host/host_flag_secret.txt' || true

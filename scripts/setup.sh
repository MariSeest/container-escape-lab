#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
docker pull alpine:latest
docker run --rm -v /:/host alpine:latest sh -c \
  'echo "HOST-FLAG{docker_socket_mount_equals_root_on_host}" > /host/host_flag_secret.txt && chmod 600 /host/host_flag_secret.txt'
docker compose -f "$HERE/environment/docker-compose.yml" up -d --build

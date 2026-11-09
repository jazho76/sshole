#!/usr/bin/env bash
set -euo pipefail

current="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
img="${IMG:-sshlab}"
port="${PORT:-2222}"

docker image inspect "$img" >/dev/null 2>&1 || "$current/build.sh"

exec docker run --rm --init --name "$img" \
  -p "127.0.0.1:$port:22" \
  "$img"

#!/bin/bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

FNM_BIN="$(command -v fnm)"
FNM_ENV="$("$FNM_BIN" env --use-on-cd --shell bash)"
eval "$FNM_ENV"

exec "$@"

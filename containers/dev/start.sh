#!/bin/bash -x
set -euo pipefail
WORKINGDIR="$1"
shift
cd "$WORKINGDIR" || exit 1
nvim "$@"

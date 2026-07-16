#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

EXECUTABLE="$PROJECT_ROOT/build/EV_HMI"

# Start AntiMicroX (PS3 Controller)
if command -v antimicrox >/dev/null 2>&1; then
    pgrep -x antimicrox >/dev/null || antimicrox >/dev/null 2>&1 &
    sleep 2
fi

exec "$EXECUTABLE"
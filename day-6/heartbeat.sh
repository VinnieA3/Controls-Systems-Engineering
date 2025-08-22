#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$HOME/controls-lab/day-6/logs"
mkdir -p "$LOG_DIR"

echo "$(date --iso-8601=seconds) heartbeat" >> "$LOG_DIR/heartbeat.log"

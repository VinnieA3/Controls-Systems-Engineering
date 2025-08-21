#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$HOME/controls-lab/day-4/logs"
LOG_FILE="$LOG_DIR/health.csv"
mkdir -p "$LOG_DIR"

# RFC3339 timestamp
ts="$(date -Iseconds)"

# 1-minute loadavg from /proc/loadavg
load1="$(awk '{print $1}' /proc/loadavg)"

# MemAvailable in kB -> MB
mem_avail_kb="$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)"
mem_avail_mb=$(( mem_avail_kb / 1024 ))

# Write header if file is new/empty
if [[ ! -s "$LOG_FILE" ]]; then
  echo "timestamp,load1,mem_available_mb" >> "$LOG_FILE"
fi

echo "$ts,$load1,$mem_avail_mb" >> "$LOG_FILE"

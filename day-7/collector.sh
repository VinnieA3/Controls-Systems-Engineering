#!/usr/bin/env bash
# Day 7 – Extended metrics collector
# Writes a CSV row every run. Safe to call from cron or a systemd timer.

set -euo pipefail

LOG_DIR="$HOME/controls-lab/day-7/logs"
CSV="$LOG_DIR/metrics.csv"
TMP="$LOG_DIR/.net.tmp"   # temp for intermediate readings

mkdir -p "$LOG_DIR"
# RFC3339 timestamp
ts="$(date -Is)"

# --- load average (1-minute) ---
load1="$(awk '{print $1}' /proc/loadavg)"

# --- memory available (kB -> MB, rounded) ---
mem_avail_kb="$(awk '/MemAvailable:/{print $2}' /proc/meminfo)"
mem_avail_mb=$(( mem_avail_kb / 1024 ))

# --- CPU usage % (vmstat sample over 1s; cpu_used = 100 - idle) ---
# First line is header, second line is the sample
cpu_idle="$(vmstat 1 2 | tail -1 | awk '{print $(NF)}')"
cpu_used="$(awk -v idle="$cpu_idle" 'BEGIN{printf "%.1f", (100 - idle)}')"

# --- root filesystem used % ---
root_used_pct="$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')"

# --- Network rx/tx rate over 1s (sum non-lo interfaces), in kbps ---
read_net() {
  awk -F'[: ]+' '
    $1 ~ /:$/ {
      iface=$1; sub(":","",iface);
      # fields: face: bytes    packets errs drop fifo frame compressed multicast bytes   ...
      #         1     2        3     4    5    6    7     8          9        10
      rxb=$2; txb=$(NF-7);    # rx bytes is field 2; tx bytes is field 10
      if (iface!="lo") { rx+=rxb; tx+=txb }
    }
    END { print rx, tx }
  ' /proc/net/dev
}
read -r rx1 tx1 < <(read_net)
sleep 1
read -r rx2 tx2 < <(read_net)

rx_kbps="$(awk -v a="$rx1" -v b="$rx2" 'BEGIN{printf "%.1f", ((b-a)*8/1024)}')"
tx_kbps="$(awk -v a="$tx1" -v b="$tx2" 'BEGIN{printf "%.1f", ((b-a)*8/1024)}')"

# Write header if file is new
if [[ ! -s "$CSV" ]]; then
  echo "timestamp,load1,cpu_used_pct,mem_available_mb,root_used_pct,rx_kbps,tx_kbps" > "$CSV"
fi

# Append row
echo "$ts,$load1,$cpu_used,$mem_avail_mb,$root_used_pct,$rx_kbps,$tx_kbps" >> "$CSV"

# Optional: also mirror a friendly log line
echo "$ts load1=$load1 cpu=${cpu_used}% mem_avail=${mem_avail_mb}MB root_used=${root_used_pct}% rx=${rx_kbps}kbps tx=${tx_kbps}kbps" >> "$LOG_DIR/collector.log"

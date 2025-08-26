#!/usr/bin/env bash
set -euo pipefail

CSV="${1:-$HOME/controls-lab/day-7/logs/metrics.csv}"
WINDOW="${2:-60}"   # last N rows (minutes) to analyze

if [[ ! -f "$CSV" ]]; then
  echo "CSV not found: $CSV" >&2
  exit 1
fi

# pull the last N real data rows (skip header if present)
# columns we expect (from Day 7 README):
# 1:timestamp 2:load1 3:mem_used_% 4:free_mb 5:disk_% 6:swap_% 7:io_wait_%
TMP="$(mktemp)"
# strip header line(s) that start with 'timestamp' just in case
grep -v -E '^timestamp' "$CSV" | tail -n "$WINDOW" > "$TMP"

total=$(wc -l < "$TMP" | tr -d ' ')
if [[ "$total" -eq 0 ]]; then
  echo "No data in last $WINDOW rows."
  rm -f "$TMP"
  exit 0
fi

# ------------- AWK: compute stats over the window -------------
# avg/min/max for load1, avg mem_used_%, min free_mb, and capture timestamps for min/max load
awk -F',' -v OFS=',' '
BEGIN {
  sum_load=0; max_load=-1e9; min_load=1e9;
  sum_mem=0;
  min_free=1e9;
}
{
  ts=$1; load=$2+0; mem=$3+0; free=$4+0;

  sum_load+=load;
  sum_mem+=mem;

  if (load>max_load) { max_load=load; max_ts=ts }
  if (load<min_load) { min_load=load; min_ts=ts }

  if (free<min_free) { min_free=free }
}
END {
  avg_load = (NR>0 ? sum_load/NR : 0);
  avg_mem  = (NR>0 ? sum_mem/NR  : 0);

  printf("Window size        : %d rows\n", NR);
  printf("Avg 1-min load     : %.3f\n", avg_load);
  printf("Max 1-min load     : %.3f at %s\n", max_load, max_ts);
  printf("Min 1-min load     : %.3f at %s\n", min_load, min_ts);
  printf("Avg mem used (%%)   : %.2f\n", avg_mem);
  printf("Min free mem (MB)  : %.0f\n", min_free);
}
' "$TMP"

echo
echo "Top 5 highest loads in the window:"
awk -F',' '
  BEGIN { print "load1,timestamp" }
  { print $2","$1 }
' "$TMP" | sort -t, -k1,1nr | head -5 | column -t -s, | awk '{printf("  %s  %s\n",$1,$2)}'

echo
echo "Any lines with high load (>= 1.50):"
awk -F',' '$2+0 >= 1.50 {printf("  %s  load=%.2f mem_used=%.1f%% free_mb=%.0f\n",$1,$2,$3,$4)}' "$TMP" | sed -e 's/^$/  (none)/'


if [[ "$total" -eq 0 ]]; then
  echo "No data in last $WINDOW rows."
  rm -f "$TMP"
  exit 0
fi

# ------------- AWK: compute stats over the window -------------
# avg/min/max for load1, avg mem_used_%, min free_mb, and capture timestamps for min/max load
awk -F',' -v OFS=',' '
BEGIN {
  sum_load=0; max_load=-1e9; min_load=1e9;
  sum_mem=0;
  min_free=1e9;
}
{
  ts=$1; load=$2+0; mem=$3+0; free=$4+0;

sum_load+=load;
  sum_mem+=mem;

  if (load>max_load) { max_load=load; max_ts=ts }
  if (load<min_load) { min_load=load; min_ts=ts }

  if (free<min_free) { min_free=free }
}
END {
  avg_load = (NR>0 ? sum_load/NR : 0);
  avg_mem  = (NR>0 ? sum_mem/NR  : 0);

  printf("Window size        : %d rows\n", NR);
  printf("Avg 1-min load     : %.3f\n", avg_load);
  printf("Max 1-min load     : %.3f at %s\n", max_load, max_ts);
  printf("Min 1-min load     : %.3f at %s\n", min_load, min_ts);
  printf("Avg mem used (%%)   : %.2f\n", avg_mem);
  printf("Min free mem (MB)  : %.0f\n", min_free);
}
' "$TMP"

echo
echo "Top 5 highest loads in the window:"
awk -F',' '
  BEGIN { print "load1,timestamp" }
  { print $2","$1 }
' "$TMP" | sort -t, -k1,1nr | head -5 | column -t -s, | awk '{printf("  %s  %s\n",$1,$2)}'

echo
echo "Any lines with high load (>= 1.50):"
awk -F',' '$2+0 >= 1.50 {printf("  %s  load=%.2f mem_used=%.1f%% free_mb=%.0f\n",$1,$2,$3,$4)}' "$TMP" | sed -e 's/^$/  (none)/'

# write a brief file too (handy for README paste later)
{
  echo "Day 8 AWK Summary (last $WINDOW rows)"
  date
  echo "CSV: $CSV"
  echo

awk -F',' -v OFS=',' '
  BEGIN {
    sum_load=0; max_load=-1e9; min_load=1e9; sum_mem=0; min_free=1e9;
  }
  {
    ts=$1; load=$2+0; mem=$3+0; free=$4+0;
    sum_load+=load; sum_mem+=mem;
    if (load>max_load) { max_load=load; max_ts=ts }
    if (load<min_load) { min_load=load; min_ts=ts }
    if (free<min_free) { min_free=free }
  }
  END {
    avg_load = (NR?sum_load/NR:0);
    avg_mem  = (NR?sum_mem/NR:0);
    printf("Rows: %d\n", NR);
    printf("AvgLoad: %.3f\n", avg_load);
    printf("MaxLoad: %.3f at %s\n", max_load, max_ts);
    printf("MinLoad: %.3f at %s\n", min_load, min_ts);
    printf("AvgMemUsed%%: %.2f\n", avg_mem);
    printf("MinFreeMB: %.0f\n", min_free);
  }' "$TMP"
} > summary.txt

rm -f "$TMP"

# Day 8 — AWK-Powered Log Queries

I wanted a quick way to analyze the CSV that my Day 7 systemd timer is producing (one row per minute of system health).  
Today I used plain **awk** to compute rolling stats without firing up Python or plotting.

## Files
- `analyze.sh` — reads a CSV and prints:
  - window size (last _N_ rows)
  - avg / max / min of 1-min load (with timestamps for min/max)
  - avg memory used (%)
  - min free memory (MB)
  - top 5 highest loads in the window
  - any lines where load ≥ 1.50 (handy for spotting spikes)
- `summary.txt` — a short summary file from the latest run.

## How I run it
```bash
# Default: analyze last 60 rows from Day 7 CSV
bash analyze.sh

# Or specify CSV + window size (e.g., last 180 rows)
bash analyze.sh ~/controls-lab/day-7/logs/metrics.csv 180

## Example Output (truncated)
Window size        : 60 rows
Avg 1-min load     : 0.312
Max 1-min load     : 1.820 at 2025-08-26T01:22:00-04:00
Min 1-min load     : 0.050 at 2025-08-26T00:59:00-04:00
Avg mem used (%)   : 27.13
Min free mem (MB)  : 1423

Top 5 highest loads in the window:
  1.820  2025-08-26T01:22:00-04:00
  1.650  2025-08-26T01:11:00-04:00
  1.420  2025-08-26T01:01:00-04:00
  0.980  2025-08-26T01:34:00-04:00
  0.900  2025-08-26T01:27:00-04:00

Any lines with high load (>= 1.50):
  2025-08-26T01:22:00-04:00  load=1.82 mem_used=33.0% free_mb=1472
  2025-08-26T01:11:00-04:00  load=1.65 mem_used=31.5% free_mb=1510


Why this matters
Having fast, CLI-only analysis lets me sanity-check the machine in seconds, triage spikes, and even script alerts if needed — all with stock tools available on any Linux box.
Next steps
Add CLI flags for thresholds (e.g., --load-alert 2.0).
Pipe awk results into mail or notify-send for simple alerts.
Join multiple CSVs (e.g., laptop + server) and compare windows.

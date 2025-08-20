# Day 3 – Log Tools

Parses a timestamped log and plots the intervals between entries.

## Files
- `parse_log.py` – reads `timestamps.log` and prints basic stats (count, min/max/avg interval).
- `plot_intervals.py` – generates `intervals.png` visualization of intervals.
- `summary.txt` – captured output from the latest run.
- `intervals.png` – latest chart.
- `.venv/` – Python virtual environment (local only).

## Quick Start
```bash
cd ~/controls-lab/day3-log-tools
python3 -m venv .venv
source .venv/bin/activate
pip install matplotlib numpy
python parse_log.py | tee summary.txt
python plot_intervals.py



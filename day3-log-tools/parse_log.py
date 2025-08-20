from pathlib import Path
from datetime import datetime
from dateutil import parser

LOG_PATH = Path("/home/vinnie/linux-service-demo/timestamps.log")

lines = LOG_PATH.read_text().strip().splitlines()
if not lines:
    print("No lines found in timestamps.log")
    raise SystemExit(0)

# lines look like: "Current time is: Tue Aug 19 01:00:01 AM EDT 2025"
times = []
for ln in lines:
    try:
        # take everything after the first colon+space
        date_str = ln.split(":", 1)[1].strip()
        dt = parser.parse(date_str)  # robust across locales/timezones
        times.append(dt)
    except Exception as e:
        print(f"Skipped line: {ln} ({e})")

print(f"Parsed {len(times)} timestamps.")
if len(times) > 1:
    diffs = [(t2 - t1).total_seconds() for t1, t2 in zip(times, times[1:])]
    print(f"Min interval: {min(diffs):.2f}s, Max: {max(diffs):.2f}s, Avg: {sum(diffs)/len(diffs):.2f}s")
else:
    print("Not enough data points for intervals.")

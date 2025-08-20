from pathlib import Path
from dateutil import parser
from datetime import datetime
import matplotlib.pyplot as plt

LOG_PATH = Path("/home/vinnie/linux-service-demo/timestamps.log")
png_out = Path("intervals.png")

lines = [ln for ln in LOG_PATH.read_text().splitlines() if ln.strip()]
times = []
for ln in lines:
    try:
        date_str = ln.split(":", 1)[1].strip()
        times.append(parser.parse(date_str))
    except Exception:
        pass

if len(times) < 2:
    print("Not enough data to plot.")
    raise SystemExit(0)

intervals = [(t2 - t1).total_seconds() for t1, t2 in zip(times, times[1:])]

plt.figure()
plt.plot(intervals, marker="o")
plt.title("Cron Interval (seconds) between timestamps")
plt.xlabel("Sample #")
plt.ylabel("Seconds")
plt.grid(True)
plt.tight_layout()
plt.savefig(png_out)
print(f"Saved {png_out.resolve()}")

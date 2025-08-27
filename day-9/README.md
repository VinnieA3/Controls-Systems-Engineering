# Day 9 – One-Command Orchestration (Makefile)

I added a root `Makefile` so I can drive this whole mini-lab with short, memorable commands:

## Quick use

```bash
# turn on the Day 7 timer (writes a CSV row every minute)
make collect-on

# check it
make status

# analyze yesterday/today's collected CSV (Day 8 awk)
make analyze

# regenerate the charts from Day 5
make plot-health

# bundle a little report (summary + charts) into day-9/out/
make report

Why this helps
Instead of remembering long commands and paths, I can type make <task>.
It also documents the workflow so future-me (or a teammate) can immediately see how to run the tools.
Notes
make report expects:
CSV from Day 7 at day-7/logs/metrics.csv.
day-8/analyze.sh available/executable.
python3 day-5/plot_health.py working (it still reads Day 4’s health.csv).
You can switch the Day 7 timer on/off with:
make collect-on
make collect-off

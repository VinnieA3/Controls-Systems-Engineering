# Day 5 – Visualizing System Health Logs

Today I extended my system health logger by adding a Python script that reads the CSV from **Day 4** and generates charts. The goal was to see the system’s load average and memory availability plotted over time.

## What I built
- A script (`plot_health.py`) that loads `day-4/logs/health.csv`.
- It parses the timestamp column, sorts rows, and then produces two charts:
  - **load_vs_time.png** – shows the 1-minute system load over time.
  - **mem_vs_time.png** – shows available memory (in MB) over time.
- Both charts are saved inside the `day-5/` folder.

## Why this matters
Being able to *visualize* system health makes trends easier to spot compared to raw numbers. For example, I can quickly see if memory is dropping steadily or if load spikes happen at certain times.

## How I ran it
```bash
python3 ~/controls-lab/day-5/plot_health.py

## That Produced:
Saved plots:
 - /home/vinnie/controls-lab/day-5/load_vs_time.png
 - /home/vinnie/controls-lab/day-5/mem_vs_time.png


Next steps
Automate the plotting step (maybe with cron like in Day 4).
Experiment with more metrics (CPU%, disk usage).
Export charts into a report format for sharing.

# Day 4 – Cron-based System Health Logger

For Day 4 of the controls lab, I set up a small project to automatically monitor my system’s health using a cron job. The goal was to collect a simple set of metrics every minute — the current timestamp, the 1-minute load average, and the amount of available memory in MB — and save those results to a CSV file that keeps growing over time. This gave me a way to see how my system behaves over the course of the day without having to check manually.

## What I built
I wrote a shell script (`scripts/health_logger.sh`) that runs one command to grab the current timestamp, load average, and free memory, then appends that line of data to a log file. Instead of me running the script manually, I added a cron job so the system automatically runs it every single minute in the background.

## Files
- `scripts/health_logger.sh` — the script that collects one line of metrics and appends it to the CSV.
- `logs/health.csv` — the growing CSV log containing timestamp, load1, mem_available_mb.
- `README.md` — this file, explaining what I did for Day 4.

## Cron entry
This is the line I added to my crontab so the script runs every minute:

* * * * * ~/controls-lab/day-4/scripts/health_logger.sh >> ~/controls-lab/day-4/logs/health.csv 2>&1

That means:  
- `* * * * *` = run every minute  
- run the script, append output to the log file  
- `2>&1` ensures errors also get captured in the same log

## How I checked it
To confirm it was working, I used the `watch` command to look at the last few lines of the CSV file as they were being updated:

watch -n 60 "tail -n 5 ~/controls-lab/day-4/logs/health.csv"

That let me see new rows appear every minute with updated system stats. It was a good way to verify the cron job was actually running on its own.

## Reflection
This was my first hands-on exercise using `cron` to automate system monitoring. It showed me how easy it is to schedule background tasks, and how powerful it can be to automatically gather data over time. By the end, I had a working mini health logger that runs without me needing to do anything.

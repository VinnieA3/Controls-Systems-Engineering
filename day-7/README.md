# Day 7 – Extended Metrics Collector with systemd timers

For Day 7, I extended my system monitoring by using a dedicated `systemd --user` timer instead of relying on cron. This gave me a cleaner, more integrated way of scheduling recurring tasks directly inside `systemd`. The idea was to have a small collector script that records system health metrics into a CSV file every minute.

## What I built
- A **collector script** (`collector.sh`) that captures CPU load averages, memory stats, and disk usage in a single line of CSV.
- A **systemd service unit** (`day7-collector.service`) that runs the script once.
- A **systemd timer unit** (`day7-collector.timer`) that triggers the service once per minute.

## Why this matters
Using `systemd` timers means I don’t have to depend on cron. It gives me more flexibility and is better aligned with how modern Linux systems manage background tasks. It also lets me attach priority and I/O scheduling hints to my units.

## How I checked it
I used these commands to make sure the service and timer were behaving:
```bash
systemctl --user status day7-collector.timer
journalctl --user -u day7-collector.service -n 5 --no-pager
ls -l ~/controls-lab/day-7/logs/

## The log file metrics.csv started filling up with new rows every minute, for example:
2025-08-26T01:01:00,0.46,100.0,1958,23,0.0,0.0
2025-08-26T01:02:00,0.15,100.0,1974,23,0.0,0.0


## Each row includes:
 - Timestamp
 - Load Average (1-min)
 - Memory Usage (%)
 - Free Memory (MB)
 - Disk Usage (%)
 - Swap Usage (%)
 - I/O Wait (%)

## Wrap-Up
This exercise helped me see how powerful systemd timers are compared to cron. I now have a lightweight monitoring setup that runs entirely under my user account and writes structured metrics I can later analyze or plot.

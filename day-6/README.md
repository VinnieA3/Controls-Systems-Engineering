# Day 6 – Heartbeat Service

For Day 6, I created a very simple background service using **systemd**. The idea was to simulate how a monitoring agent might run continuously in the background, independent of user input. Instead of checking CPU or memory, this service just writes a "heartbeat" line to a log file once every 60 seconds.

## What I built
- A script (`heartbeat.sh`) that logs the current timestamp and the word "heartbeat" into `day-6/logs/heartbeat.log`.
- A systemd service unit (`heartbeat.service`) that runs the script continuously, restarting it every minute.
- The service is managed by `systemctl --user`, meaning it runs in my user session.

## Why this matters
This taught me how to:
- Write a simple script that behaves like a monitoring probe.
- Register a service with systemd so it runs automatically in the background.
- Watch logs grow in real time (`tail -f`), confirming the service is working.

## How I tested it
I enabled and started the service:
```bash
systemctl --user enable --now heartbeat.service


## Then I tailed the log:
tail -f ~/controls-lab/day-6/logs/heartbeat.log


## Every minute, I could see a new entry like:
2025-08-22T00:45:00-04:00 heartbeat


## Wrap up
This was my first practice with systemd service units. While simple, it made me more comfortable with the idea of creating lightweight monitoring or automation tasks that always run in the background without needing cron.

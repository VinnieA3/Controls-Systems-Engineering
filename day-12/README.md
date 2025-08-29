# Day 12 – Makefile Integration with Docker

For this day, I connected my Docker workflow into a `Makefile` so I can run repeatable commands with a simple `make`.  
This saves me from remembering long `docker build` or `docker run` commands. Instead, I can just type:

- `make docker-build` – builds the container image for plotting  
- `make check-csv` – ensures my `day-4/logs/health.csv` file exists before trying to plot  
- `make docker-plot` – runs the container and generates PNGs  

When it runs, I expect the container to produce:

- `/controls-lab/day-5/load_vs_time.png`  
- `/controls-lab/day-5/mem_vs_time.png`  

This ties together the work from earlier days (system health logs + plotting) into a repeatable, automated build pipeline.

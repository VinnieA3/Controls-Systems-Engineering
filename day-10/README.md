# Day 10 – Containerized Plotting (Docker)

I containerized my Day 5 plotting script so I can run it in a clean, repeatable
environment. The container expects the repo mounted at `/work/controls-lab`
and uses my Day 4 CSV (`day-4/logs/health.csv`) as input.

## How I ran it

```bash
# build image
docker build -t controls-lab-day10 ~/controls-lab/day-10

# run with repo mounted; pass HOME=/work so code finds /work/controls-lab/day-4/logs/health.csv
docker run --rm \
  -v ~/controls-lab:/work/controls-lab \
  -e HOME=/work \
  controls-lab-day10 \
  python /work/controls-lab/day-5/plot_health.py


That produced (or refreshed):
/work/controls-lab/day-5/load_vs_time.png
/work/controls-lab/day-5/mem_vs_time.png
On the host these land at:
~/controls-lab/day-5/load_vs_time.png
~/controls-lab/day-5/mem_vs_time.png
Notes
I overrode the container command to point at the correct in-container path
(/work/controls-lab/day-5/plot_health.py), since the repo is mounted at
/work/controls-lab.
If I want this to be the default, I can change the Dockerfile’s CMD to that
path and skip the explicit python ... in docker run.

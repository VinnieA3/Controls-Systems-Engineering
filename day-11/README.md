# Day 11 – One-Command Container Runs (Makefile targets)

I kept containerizing from Day 10, but wired it into my top-level Makefile so I can:
- build the plotting image
- run the container with my repo mounted
- generate charts from my Day 4 CSV
…all with simple `make` commands.

## Why
Typing long `docker run` flags is error-prone. Targets make it repeatable and self-documenting.

## What I added
- `make docker-build` – builds the image from `day-10/Dockerfile`
- `make docker-plot` – runs the container and calls my Day 5 plotting script
- `make docker-run` – opens an interactive shell in the image (mounted repo)
- `make check-csv` – quick sanity check that `day-4/logs/health.csv` exists

## Expected output
When I run `make docker-plot` I expect:
- the container to print “Saved plots: …”
- two PNGs updated on the host:
  - `~/controls-lab/day-5/load_vs_time.png`
  - `~/controls-lab/day-5/mem_vs_time.png`

If CSV is missing, `make check-csv` tells me before I run the container.

That’s it—now it’s muscle memory: `make docker-build && make docker-plot`.

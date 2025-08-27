FROM python:3.11-slim

# Install libs needed by your plotting script
RUN pip install --no-cache-dir pandas matplotlib

# Workdir inside container; we will bind-mount the repo here
WORKDIR /work

# Headless matplotlib default (helps on minimal containers)
ENV MPLBACKEND=Agg

# By default, run your plot script (which lives in the bind mount)
CMD ["python", "/work/day-5/plot_health.py"]

from pathlib import Path
from datetime import datetime
import pandas as pd
import matplotlib.pyplot as plt

# ---- Config ----
CSV_PATH = Path.home() / "controls-lab" / "day-4" / "logs" / "health.csv"
OUT_DIR = Path.home() / "controls-lab" / "day-5"
OUT_DIR.mkdir(parents=True, exist_ok=True)
PNG_LOAD = OUT_DIR / "load_vs_time.png"
PNG_MEM = OUT_DIR / "mem_vs_time.png"

# ---- Load data ----
if not CSV_PATH.exists():
    raise SystemExit(f"Input CSV not found: {CSV_PATH}")

df = pd.read_csv(CSV_PATH)
# Expect columns: timestamp,load1,mem_available_mb
# Parse timestamp
df["timestamp"] = pd.to_datetime(df["timestamp"], errors="coerce")
df = df.dropna(subset=["timestamp"]).sort_values("timestamp")

# ---- Plot load vs time ----
plt.figure(figsize=(10,4))
plt.plot(df["timestamp"], df["load1"], label="1-min load", marker="o", linewidth=1)
plt.title("System Load Over Time")
plt.xlabel("Timestamp")
plt.ylabel("Load1")
plt.grid(True)
plt.tight_layout()
plt.savefig(PNG_LOAD)
plt.close()

# ---- Plot mem vs time ----
plt.figure(figsize=(10,4))
plt.plot(df["timestamp"], df["mem_available_mb"], label="Available Memory (MB)", marker="o", linewidth=1)
plt.title("Available Memory Over Time")
plt.xlabel("Timestamp")
plt.ylabel("Memory (MB)")
plt.grid(True)
plt.tight_layout()
plt.savefig(PNG_MEM)
plt.close()

print(f"Saved plots:\n - {PNG_LOAD}\n - {PNG_MEM}")

# -------- controls-lab Makefile (Day 9) --------
# One-liners to manage the mini-lab:
#   make help
#   make collect-on / collect-off / collect-once / status
#   make analyze
#   make plot-health
#   make report
#   make clean

# --- Paths ---
DAY4_DIR := day-4
DAY5_DIR := day-5
DAY7_DIR := day-7
DAY8_DIR := day-8
DAY9_DIR := day-9

LOG_CSV   := $(DAY7_DIR)/logs/metrics.csv
ANALYZE   := $(DAY8_DIR)/analyze.sh
PLOT_PY   := $(DAY5_DIR)/plot_health.py
OUT_DIR   := $(DAY9_DIR)/out

# Make is noisy by default; we’ll keep it friendly
.SILENT:

.PHONY: help collect-on collect-off collect-once status analyze plot-health report clean check-csv check-tools

help:
	@echo ""
	@echo "controls-lab — convenience targets"
	@echo "----------------------------------"
	@echo " make collect-on     # enable & start Day 7 timer (user) "
	@echo " make collect-off    # stop & disable Day 7 timer"
	@echo " make collect-once   # run Day 7 collector service one time"
	@echo " make status         # see Day 7 timer + last service logs"
	@echo " make analyze        # run awk analysis on Day 7 CSV"
	@echo " make plot-health    # generate Day 5 charts (uses Day 4 CSV)"
	@echo " make report         # write summary & copy charts into day-9/out/"
	@echo " make clean          # remove day-9/out/"
	@echo ""

# --- Collector controls (Day 7) ---
collect-on:
	systemctl --user enable --now day7-collector.timer
	@echo ">> day7-collector.timer enabled & started"

collect-off:
	systemctl --user disable --now day7-collector.timer || true
	@echo ">> day7-collector.timer disabled & stopped"

collect-once:
	systemctl --user start day7-collector.service
	@echo ">> day7-collector.service triggered once"

status:
	systemctl --user list-timers --all | grep -E "day7-collector|NEXT|UNIT" || true
	journalctl --user -u day7-collector.service -n 5 --no-pager || true

# --- Safety checks ---
check-csv:
	@if [ ! -f "$(LOG_CSV)" ]; then \
		echo "ERROR: CSV not found: $(LOG_CSV)"; \
		echo "Hint: run 'make collect-on' for a few minutes, or 'make collect-once' to generate a row."; \
		exit 1; \
	fi

check-tools:
	@command -v awk >/dev/null 2>&1 || { echo "awk not found"; exit 1; }
	@command -v python3 >/dev/null 2>&1 || { echo "python3 not found"; exit 1; }
	@if [ ! -f "$(ANALYZE)" ]; then echo "Missing analyzer: $(ANALYZE)"; exit 1; fi
	@if [ ! -f "$(PLOT_PY)" ]; then echo "Missing plotter: $(PLOT_PY)"; exit 1; fi

# --- Analysis (Day 8) ---
analyze: check-tools check-csv
	# analyze.sh prints a summary to stdout; redirect as needed
	bash "$(ANALYZE)" "$(LOG_CSV)"

# --- Plots (Day 5) ---
plot-health: check-tools
	python3 "$(PLOT_PY)"

# --- Report (bundle summary + charts) ---
report: check-tools check-csv
	mkdir -p "$(OUT_DIR)"
	# Save analysis summary
	bash "$(ANALYZE)" "$(LOG_CSV)" > "$(OUT_DIR)/summary.txt"
	# Copy charts from Day 5 if present
	if ls "$(DAY5_DIR)"/*.png >/dev/null 2>&1; then \
		cp "$(DAY5_DIR)"/*.png "$(OUT_DIR)"/; \
		echo "Copied charts into $(OUT_DIR)/"; \
	else \
		echo "No charts found in $(DAY5_DIR)/ (run 'make plot-health' first if you want them in the report)"; \
	fi
	@echo "Report ready in: $(OUT_DIR)/"

clean:
	rm -rf "$(OUT_DIR)"
	@echo "Removed $(OUT_DIR)/"
# -------- end Makefile --------

#!/bin/bash
# Daily User Log Archiver - Full Version (Downloads folder, Older than 7 Days)


# --- Step 1: Identify user ---
USER_NAME=$(whoami)
echo "Script run by: $USER_NAME"

# --- Step 2: Create log directory and save daily log ---
LOG_DIR=/home/wizzz/Desktop/linux_lab/dailylogs
mkdir -p "$LOG_DIR"

LOGFILE="$LOG_DIR/log_$(date +%Y-%m-%d).txt"

{
  echo "User: $USER_NAME"
  echo "Date: $(date)"
  echo "----------------------------------------"
  echo "System Uptime:"
  uptime
  echo "----------------------------------------"
  echo "Top 5 CPU Consuming Processes:"
  ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -n 6
  echo "----------------------------------------"
  echo "Disk Usage:"
  df -h
} > "$LOGFILE"

echo " Daily log saved: $LOGFILE"

# --- Step 3: Weekly archive (Monday only) ---
ARCHIVE_DIR=/home/wizzz/Desktop/linux_lab/dailylogs/archive
mkdir -p "$ARCHIVE_DIR"

DAY_OF_WEEK=$(date +%u)  # 1 = Monday
if [ "$DAY_OF_WEEK" -eq 1 ]; then
  tar -czf "$ARCHIVE_DIR/weeklylogs_$(date +%Y-%m-%d).tar.gz" -C "$LOG_DIR" .
  echo " Weekly archive created."
fi

# --- Step 4: Move logs older than 7 days ---
for file in "$LOG_DIR"/log_*.txt; do
  if [ -f "$file" ] && [ $(find "$file" -mtime +7) ]; then
    mv "$file" "$ARCHIVE_DIR/"
    echo "Moved $file to archive"
  fi
done

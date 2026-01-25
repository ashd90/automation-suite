#!/bin/bash

# --- 1. Variables (Clean & Maintainable) ---
BACKUP_DIR="$HOME/repoHive/devbox/automation-suite/"
CONFIG_SRC="$HOME/.config"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_FILE="$BACKUP_DIR/backup.log"

# --- 2. Define target apps to track ---
TARGETS=("ghostty", "nvim")

echo "[$TIMESTAMP] Starting Config Backup..." | tee -a "$LOG_FILE"

# --- 3. Sync Files (Using 'cp' or 'rsync') ---
for item in "${TARGETS[@]}"; do
  if [ -d "$CONFIG_SRC/$item" ]; then
    mkdir -p "$BACKUP_DIR/$item"
    cp -r "$CONFIG_SRC/$item/"* "$BACKUP_DIR/$item/"
    echo "Successfully synced: $item" | tee -a "$LOG_FILE"
  else
    echo "Warning: $item config not found!" | tee -a "$LOG_FILE"
  fi
done

# --- 4. GitOps Automation ---
cd "$BACKUP_DIR" || exit

# Check if there are actual changes before committing
if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "Automated backup: $TIMESTAMP"
  git push origin main
  echo "Changes committed to Git." | tee -a "$LOG_FILE"
else
  echo "No changes detected. Skipping commit." | tee -a "$LOG_FILE"
fi

echo "-------------------------------------" >>"$LOG_FILE"

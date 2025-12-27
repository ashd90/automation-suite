#!/bin/bash

# --- 1. Colors for "Pro" Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# --- 2. Get the Stats ---
# We use 'printf "%.0f"' to round the decimal to a whole number
RAM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "--- System Health Check ---"

# --- 3. RAM Logic ---
if [ "$RAM_USAGE" -gt 80 ]; then
    echo -e "RAM Usage: ${RED}${RAM_USAGE}% - CRITICAL${NC}"
else
    echo -e "RAM Usage: ${GREEN}${RAM_USAGE}% - OK${NC}"
fi

# --- 4. Disk Logic ---
if [ "$DISK_USAGE" -gt 90 ]; then
    echo -e "Disk Usage: ${RED}${DISK_USAGE}% - LOW SPACE${NC}"
else
    echo -e "Disk Usage: ${GREEN}${DISK_USAGE}% - OK${NC}"
fi

# --- 1. Get CPU Load ---
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | awk -F',' '{ print $1 }' | xargs)

# --- 2. CPU Logic (Job-Ready Strategy) ---
# Since CPU_LOAD is a decimal (like 0.45), we use 'bc' to compare
# First, install bc: sudo pacman -S bc
CPU_THRESHOLD=10.0

if (( $(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l) )); then
    echo -e "CPU Load: ${RED}${CPU_LOAD}${NC} - HIGH LOAD"
else
    echo -e "CPU Load: ${GREEN}${CPU_LOAD}${NC} - OK"
fi

# --- 3. Update CSV Logging ---
echo "$(date '+%Y-%m-%d %H:%M:%S'),$RAM_USAGE,$DISK_USAGE,$CPU_LOAD" >> system_stats.csv

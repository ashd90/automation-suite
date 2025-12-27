#!/bin/bash

# --- Function to show help ---
usage() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  --backup   : Run the configuration backup & git push"
    echo "  --health   : Check CPU, RAM, and Disk health"
    echo "  --help     : Show this help message"
}

# --- The Logic ---
case "$1" in
    --backup)
        echo "Starting Backup..."
        ./backup_configs.sh
        ;;
    --health)
        echo "Starting Health Check..."
        ./monitor_system.sh
        ;;
    --help)
        usage
        ;;
    *)
        # This handles anything else the user types
        echo -e "Error: Invalid option '$1'"
        usage
        exit 1
        ;;
esac

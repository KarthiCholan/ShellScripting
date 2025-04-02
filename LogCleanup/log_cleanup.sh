#!/bin/bash

# Configuration - Set log directory and retention period
LOG_DIR="/var/log"  # Change this to your log directory path
DAYS=30  # Delete files older than 30 days
LOG_FILE="/var/log/log_cleanup.log"

# Find and delete logs older than $DAYS days
echo "$(date) - Cleaning up log files older than $DAYS days in $LOG_DIR" >> $LOG_FILE
find $LOG_DIR -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;

# Optional: Also clean up compressed log files (.gz)
find $LOG_DIR -type f -name "*.gz" -mtime +$DAYS -exec rm -f {} \;

echo "$(date) - Cleanup completed." >> $LOG_FILE

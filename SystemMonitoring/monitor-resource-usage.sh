#!/bin/bash

# Configuration - Set Alert Thresholds
THRESHOLD_CPU=90     # Alert if CPU usage exceeds 90%
THRESHOLD_DISK=80    # Alert if disk usage exceeds 80%
THRESHOLD_MEM=90     # Alert if memory usage exceeds 90%
ALERT_EMAIL="your@email.com"  # Change to your email
HOSTNAME=$(hostname)
LOG_FILE="/var/log/resource_monitor.log"

# Function to send email alert
send_alert() {
    SUBJECT=$1
    MESSAGE=$2
    echo -e "Subject:$SUBJECT\n\n$MESSAGE" | sendmail -v "$ALERT_EMAIL"
}

# Get CPU Usage (average over 1 minute)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)

# Get Disk Usage (Root partition "/")
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Get Memory Usage
MEM_USAGE=$(free | awk '/Mem/{printf("%.0f"), $3/$2 * 100}')

# Log file
echo "$(date) - CPU: ${CPU_USAGE}%, Disk: ${DISK_USAGE}%, Memory: ${MEM_USAGE}%" >> $LOG_FILE

# Check CPU Usage
if [ "$CPU_USAGE" -gt "$THRESHOLD_CPU" ]; then
    MESSAGE="WARNING: CPU usage on $HOSTNAME is at ${CPU_USAGE}%"
    echo "$MESSAGE"
    send_alert "CPU Usage Alert - $HOSTNAME" "$MESSAGE"
fi

# Check Disk Usage
if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
    MESSAGE="WARNING: Disk usage on $HOSTNAME is at ${DISK_USAGE}%"
    echo "$MESSAGE"
    send_alert "Disk Space Alert - $HOSTNAME" "$MESSAGE"
fi

# Check Memory Usage
if [ "$MEM_USAGE" -gt "$THRESHOLD_MEM" ]; then
    MESSAGE="WARNING: Memory usage on $HOSTNAME is at ${MEM_USAGE}%"
    echo "$MESSAGE"
    send_alert "Memory Usage Alert - $HOSTNAME" "$MESSAGE"
fi

#!/bin/bash

# Set the maximum allowed disk usage percentage
max_disk_usage=85

# Get the list of all mounted partitions excluding temporary filesystems like tmpfs
partitions=$(df -h | grep -E '^/dev/' | awk '{print $1}')

# Iterate over each partition and check disk usage
for part in $partitions; do
    # Get the disk usage percentage of the current partition
    usage=$(df -h | grep $part | awk '{print $5}' | cut -d '%' -f1)

    # Check if the partition was found
    if [ -z "$usage" ]; then
        echo "Partition $part not found or unable to read usage."
        continue
    fi

    # Compare the current disk usage with the maximum allowed
    if [ "$usage" -gt "$max_disk_usage" ]; then
        echo "DISK OUT OF ALLOWED USAGE: Partition $part is at ${usage}%"
    else
        echo "Disk usage is within the allowed limit: Partition $part is at ${usage}%"
    fi
done


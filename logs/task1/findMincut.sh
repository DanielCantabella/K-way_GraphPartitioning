#!/bin/bash

# Define the log file
LOG_FILE="add20.graph.txt"

# Extract edge cut values and find the minimum
MIN_EDGE_CUT=$(grep "edge cut:" "$LOG_FILE" | awk -F 'edge cut:' '{print $2}' | sort -n | head -n 1)

# Print the minimum edge cut
echo "Minimum Edge Cut: $MIN_EDGE_CUT"

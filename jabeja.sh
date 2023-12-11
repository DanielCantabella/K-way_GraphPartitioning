
#!/bin/bash

graph="3elt.graph"

# Use time command to measure elapsed time
{ /usr/bin/time -p ./run.sh -temp 2.0 -rounds 1000 -delta 0.003 -graph "graphs/${graph}" 2>&1; } | tee "./logs/task1/${graph}.txt"

# Define the log file
LOG_FILE="./logs/task1/${graph}.txt"

# Extract edge cut values and find the minimum
MIN_EDGE_CUT=$(grep "edge cut:" "$LOG_FILE" | awk -F 'edge cut:' '{print $2}' | sort -n | head -n 1)

# Print the minimum edge cut
echo "Minimum Edge Cut: $MIN_EDGE_CUT"


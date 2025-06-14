#!/bin/bash

# --- Description ---
# Scans all nX node folders in the current directory
# Looks in each node's ./node.log for the last "validated blocks at" line
# Extracts and prints the block height from that line

echo "📡 Checking sync heights from node logs..."

for NODE_DIR in ./n[0-9]*; do
  LOG_FILE="${NODE_DIR}/node.log"
  NODE_NAME=$(basename "$NODE_DIR")

  if [[ -f "$LOG_FILE" ]]; then
    # Clean and search log
    LAST_LINE=$(strings "$LOG_FILE" \
      | grep -i "validated blocks at" \
      | tail -n 1)

    if [[ -n "$LAST_LINE" ]]; then
      # Extract numeric block height (last number in the line)
      HEIGHT=$(echo "$LAST_LINE" | grep -oE '[0-9]+(\.[0-9]+)+' | tail -n 1)
      echo "$NODE_NAME: block height $HEIGHT"
    else
      echo "$NODE_NAME: no match found"
    fi
  else
    echo "$NODE_NAME: log file missing"
  fi
done

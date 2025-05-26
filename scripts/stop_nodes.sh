#!/bin/bash

ROOT_DIR="/root/nockchain"
SOCKET_FILENAME="nockchain_npc.sock"

echo "Stopping all nockchain nodes under $ROOT_DIR..."

# Kill all nockchain processes
PIDS=$(pgrep -f "nockchain")

if [ -n "$PIDS" ]; then
  echo "Force killing all nockchain processes (PIDs: $PIDS)"
  kill -9 $PIDS
else
  echo "No nockchain processes found."
fi

# Wait for cleanup
echo "Waiting 10 seconds before removing socket files..."
sleep 10

# Loop over all node directories and delete socket files
for NODE_DIR in "${ROOT_DIR}"/n*; do
  if [ -d "$NODE_DIR" ]; then
    SOCKET_PATH="${NODE_DIR}/.socket/${SOCKET_FILENAME}"
   #sockets are not regular files, so -s option. 
   if [ -S "$SOCKET_PATH" ]; then
      echo "Deleting socket file $SOCKET_PATH"
      rm -f "$SOCKET_PATH"
    else
      echo "WARNING: Socket file $SOCKET_PATH not found."
    fi
  else
    echo "WARNING: $NODE_DIR is not a valid directory, skipping."
  fi
done
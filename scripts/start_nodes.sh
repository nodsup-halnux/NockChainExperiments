#!/bin/bash

# Prompt before starting
read -p "Did you run 'sudo sysctl -w vm.overcommit_memory=1' before starting? [Y/N] " answer
case "$answer" in
  [Yy]* ) echo "Starting nodes...";;
  * ) echo "Please run 'sudo sysctl -w vm.overcommit_memory=1' first. Exiting."; exit 1;;
esac

# Configuration
ROOT_DIR="/root/nockchain"       # Adjust if needed
TOTAL_NODES=5                    # Change as needed
NODE_PREFIX="n"

# Launch each node
#UL is inclusive]
for i in $(seq 1 $TOTAL_NODES); do
  #make all absolute paths - no ambiguity.
  NODE_DIR="${ROOT_DIR}/${NODE_PREFIX}${i}"
  ENV_FILE="${NODE_DIR}/.env"
  LOG_FILE="${NODE_DIR}/node.log"
  SOCKET_PORT=$((8000 + i))

  if [ -f "$ENV_FILE" ]; then
    echo "Starting node $NODE_DIR with UDP port $SOCKET_PORT..."

    cd "$NODE_DIR" || { echo "Failed to enter $NODE_DIR"; continue; }

    # Load environment variables
    set -a
    source "$ENV_FILE"
    set +a

    # Export critical vars
    #This is apparently for defensive  coding - but our script is simple.
    #export RUST_LOG
    #export MINIMAL_LOG_FORMAT
    #export MINING_PUBKEY

    # Run node in background
    #use tail -n <X> to see the latest lines.
    #nohup keeps process alive if ssh terminal disconnects.
    nohup nockchain \
      --mining-pubkey "${MINING_PUBKEY}" \
      --mine \
      --bind "/ip4/0.0.0.0/udp/${SOCKET_PORT}/quic-v1" \
      >> "$LOG_FILE" 2>&1 &

  else
    echo "Environment file $ENV_FILE missing, skipping node $NODE_DIR"
  fi
done
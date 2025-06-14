#!/bin/bash

# --- Help Message ---
if [[ "$1" == "--help" ]]; then
  echo "Usage: ./sync_nodes.sh [--jam-name <jamfile.jam>]"
  echo
  echo "Options:"
  echo "  --jam-name <name>   Use a specific jam file from /root/nockchain/blockjumps/"
  echo "                      If omitted, nodes will sync from genesis or previous state."
  echo
  echo "  --help              Show this help message and exit."
  echo
  echo "Description:"
  echo "  Launches multiple NockChain nodes in non-mining sync mode."
  echo "  If a jam file is specified and valid, it will be used to fast-forward sync."
  echo
  exit 0
fi

# --- CLI Option: --jam-name <name> ---
JAM_NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --jam-name)
      JAM_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Use --help to view usage."
      exit 1
      ;;
  esac
done

# --- Configuration ---
ROOT_DIR="/root/nockchain"
JAM_DIR="${ROOT_DIR}/blockjumps"
TOTAL_NODES=3
NODE_PREFIX="n"

# --- Launch each node ---
for i in $(seq 1 $TOTAL_NODES); do
  NODE_DIR="${ROOT_DIR}/${NODE_PREFIX}${i}"
  ENV_FILE="${NODE_DIR}/.env"
  LOG_FILE="${NODE_DIR}/node.log"
  SOCKET_PORT=$((8000 + i))

  if [ -f "$ENV_FILE" ]; then
    echo "Starting node $NODE_DIR on UDP port $SOCKET_PORT..."

    cd "$NODE_DIR" || { echo "Failed to enter $NODE_DIR"; continue; }

    set -a
    source "$ENV_FILE"
    set +a

    if [[ -n "$JAM_NAME" ]]; then
      JAM_PATH="${JAM_DIR}/${JAM_NAME}"
      if [[ -f "$JAM_PATH" ]]; then
        echo "  ↪ Using jam state: $JAM_PATH"
        nohup nockchain \
          --mining-pubkey "${MINING_PUBKEY}" \
          --peer /dnsaddr/nockchain-backbone.zorp.io \
          --bind "/ip4/0.0.0.0/udp/${SOCKET_PORT}/quic-v1" \
          --state-jam "$JAM_PATH" \
          >> "$LOG_FILE" 2>&1 &
      else
        echo "❌ Jam file not found: $JAM_PATH — node $NODE_DIR not started"
      fi
    else
      nohup nockchain \
        --mining-pubkey "${MINING_PUBKEY}" \
        --peer /dnsaddr/nockchain-backbone.zorp.io \
        --bind "/ip4/0.0.0.0/udp/${SOCKET_PORT}/quic-v1" \
        >> "$LOG_FILE" 2>&1 &
    fi

  else
    echo "⚠️  Missing env file: $ENV_FILE — skipping node $NODE_DIR"
  fi
done

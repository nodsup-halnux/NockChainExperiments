# Nockchain

**Nockchain is a lightweight blockchain for heavyweight verifiable applications.**


We believe the future of blockchains is lightweight trustless settlement of heavyweight verifiable computation. The only way to get there is by replacing verifiability-via-public-replication with verifiability-via-private-proving. Proving happens off-chain; verification is on-chain.

*Nockchain is entirely experimental and many parts are unaudited. We make no representations or guarantees as to the behavior of this software.*


## Setup

Install `rustup` by following their instructions at: [https://rustup.rs/](https://rustup.rs/)

Ensure you have these dependencies installed if running on Debian/Ubuntu:
```
sudo apt update
sudo apt install clang llvm-dev libclang-dev make
```

Now clone this github repo:

```sh
git clone https://github.com/zorp-corp/nockchain.git
sudo reboot

```

**Restart your machine on Digital Ocean**


Move into the nockchain folder you got from cloning.
Copy the example environment file and rename it to `.env`:
```
cd nockchain
cp .env_example .env
```

Install `hoonc`, the Hoon compiler:

```
make install-hoonc
export PATH="$HOME/.cargo/bin:$PATH"
```

To build the Nockchain and the wallet binaries and their required assets:

```
make build
```

## Install Wallet

After you've run the setup and build commands, install the wallet:

```
make install-nockchain-wallet
export PATH="$HOME/.cargo/bin:$PATH"
```

You may get rust warnings. The compilation takes a long time. Look through the terminal log, and apply any rust commands to clear the warnings. For example, you might see:

```sh
cargo fix --lib -p nockchain
```

See the nockchain-wallet [README](./crates/nockchain-wallet/README.md) for more information.

### Quick Nockchain Wallet Guide:




## Install Nockchain

After you've run the setup and build commands, install Nockchain:

```sh
make install-nockchain
export PATH="$HOME/.cargo/bin:$PATH"
#Clean up your path, you ran export with the same path too many times!
export PATH=$(echo "$PATH" | awk -v RS=':' '!seen[$0]++' | paste -sd:)

#Adjust your .bashrc so that you don't have to re-export your path every session:

"case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) :;; # already in PATH
  *) export PATH="$HOME/.cargo/bin:$PATH";;
esac"

```

## Setup Keys

To generate a new key pair:

```
nockchain-wallet keygen
```

This will print a new public/private key pair + chain code to the console, as well as the seed phrase for the private key.

Now, copy the public key to the `.env` file:

```
MINING_PUBKEY=<public-key>
```

## Backup Keys

To backup your keys, run:

```
nockchain-wallet export-keys
```

This will save your keys to a file called `keys.export` in the current directory.

They can be imported later with:

```
nockchain-wallet import-keys --input keys.export
```

Finally, we need a console htop like program to monitor CPU/RAM usage. Install:

```sh
sudo apt install bpytop

```


## Running Nodes

Make sure your current directory is nockchain.

To run a Nockchain node without mining.

Check to see if things basically work with the script below:


```
sh ./scripts/run_nockchain_node.sh
```

You may need to run the following, to find the $MINING_PUBKEY variable.:

```sh
source ~/nockchain/.env

```


To run a Nockchain node and mine to a pubkey:

```
sh ./scripts/run_nockchain_miner.sh
```

For launch, make sure you run in a fresh working directory that does not include a .data.nockchain file from testing.


## FAQ

### Can I use same pubkey if running multiple miners?

Yes, you can use the same pubkey if running multiple miners.

### How do I change the mining pubkey?

Run `nockchain-wallet keygen` to generate a new key pair.

If you are using the Makefile workflow, copy the public key to the `.env` file.

### How do I run multiple instances on the same machine?

To run multiple instances on the same machine, you need to:

1. Create separate working directories for each instance
2. Use different ports for each instance

Here's how to set it up:

```bash
Inside of the nockchain directory:

# Create directories for each instance
mkdir node1 node2

# Copy .env to each directory
cp .env node1/
cp .env node2/

# Run each instance in its own directory with .env loaded
cd node1 && sh ../scripts/run_nockchain_miner.sh
cd node2 && sh ../scripts/run_nockchain_miner.sh
```

### What are the networking requirements?

Nockchain requires:

1. Internet.
2. If you are behind a firewall, you need to specify the p2p ports to use and open them..
   - Example: `nockchain --bind /ip4/0.0.0.0/udp/$PEER_PORT/quic-v1`
3. **NAT Configuration (if you are behind one)**:
   - If behind NAT, configure port forwarding for the peer port
   - Use `--bind` to specify your public IP/domain
   - Example: `nockchain --bind /ip4/1.2.3.4/udp/$PEER_PORT/quic-v1`

### Why aren't Zorp peers connecting?

Common reasons for peer connection failures:

1. **Network Issues**:
   - Firewall blocking P2P port
   - NAT not properly configured
   - Incorrect bind address

2. **Configuration Issues**:
   - Invalid peer IDs

3. **Debug Steps**:
   - Check logs for connection errors
   - Verify port forwarding

### What do outgoing connection failures mean?

Outgoing connection failures can occur due to:

1. **Network Issues**:
   - Peer is offline
   - Firewall blocking connection
   - NAT traversal failure

2. **Peer Issues**:
   - Peer has reached connection limit
   - Peer is blocking your IP

3. **Debug Steps**:
   - Check peer's status
   - Verify network connectivity
   - Check logs for specific error messages

### How do I know if it's mining?

No way to manually check mining status yet. We're working on it.

In the meantime, you can check the logs for mining activity.

If you see a line that looks like:

```sh
[%mining-on 12.040.301.481.503.404.506 17.412.404.101.022.637.021 1.154.757.196.846.835.552 12.582.351.418.886.020.622 6.726.267.510.179.724.279]
```

### How do I check block height?

No way to manually check block height yet. We're working on it.

In the meantime, you can check the logs for a line like:

```sh
block Vo3d2Qjy1YHMoaHJBeuQMgi4Dvi3Z2GrcHNxvNYAncgzwnQYLWnGVE added to validated blocks at 2
```

That last number is the block height.

### What do common errors mean?

Common errors and their solutions:

1. **Connection Errors**:
   - `Failed to dial peer`: Network connectivity issues, you may still be connected though.
   - `Handshake with the remote timed out`: Peer might be offline, not a fatal issue.

### How do I check wallet balance?

To check your wallet balance:

```bash
# List all notes (UTXOs) that your node has seen
nockchain-wallet --nockchain-socket ./nockchain.sock list-notes

# List all notes by pubkey
nockchain-wallet --nockchain-socket ./nockchain.sock list-notes-by-pubkey <your-pubkey>
```

### How do I configure logging levels?

To reduce logging verbosity, you can set the `RUST_LOG` environment variable before running nockchain:

```bash
# Show only info and above
RUST_LOG=info nockchain

# Show only errors
RUST_LOG=error nockchain

# Show specific module logs (e.g. only p2p events)
RUST_LOG=nockchain_libp2p_io=info nockchain

# Multiple modules with different levels
RUST_LOG=nockchain_libp2p_io=info,nockchain=warn nockchain
```

Common log levels from most to least verbose:
- `trace`: Very detailed debugging information
- `debug`: Debugging information
- `info`: General operational information
- `warn`: Warning messages
- `error`: Error messages

You can also add this to your `.env` file if you're running with the Makefile:
```
RUST_LOG=info
```

### Troubleshooting Common Issues

1. **Node Won't Start**:
   - Check port availability
   - Verify .env configuration
   - Check for existing .data.nockchain file
   - Ensure proper permissions

2. **No Peers Connecting**:
   - Verify port forwarding
   - Check firewall settings

3. **Mining Not Working**:
   - Verify mining pubkey
   - Check --mine flag
   - Ensure peers are connected
   - Check system resources

4. **Wallet Issues**:
   - Verify key import/export
   - Check socket connection
   - Ensure proper permissions



## ToDO;
- logout and back in. Is the $PATH variable correct? [X]
- get single instance running. [X]
- 7 threads scripts - how to link them together internally?
- nockchain-wallet rapper (For .socket flags to shorten command string.)
- ssh key config (move away from password).
- get ufw working (when everything setup optimally).
- snapshot []

## Dealing with errors:

`E (16:28:47) nc: Could not create swarm: Error: Os { code: 98, kind: AddrInUse, message: "Address already in use" }`
Solution: I had 1.2.3.4 in the bind address. Set it to bind to any address 0.0.0.0 (which is 127.0.0.1 and external IP)

`SEvent: friendship ended with 12D3KooWCnQHkYZToT7o1f7hxKuVgiaYXs5cJugr3gujpViVRvs5 via: Dialer { address: /dnsaddr/nockchain-backbone.zorp.io, role_override: Dialer, port_use: Reuse }. cause: Some(KeepAliveTimeout)`
Solution: Not technically a problem, miner still runs and mines. Sometimes it takes a while to connect to the backbone network - be patient.

```
thread 'serf' panicked at crates/nockvm/rust/nockvm/src/mem.rs:301:23:
Box<dyn Any>
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

thread 'tokio-runtime-worker' panicked at crates/nockchain/src/mining.rs:175:14:
Could not load mining kernel: OneshotChannelError(RecvError(()))
W (16:36:32) mining: Error during mining attempt: JoinError::Panic(Id(108), "Could not load mining kernel: OneshotChannelError(RecvError(()))", ...)

```
- Here, is the solution at:https://forum.nockchain.org/t/could-not-load-mining-kernel/526/13

Solution: Linux kernel won't allow memory overcommit. You need to permit it. Run `sudo sysctl -w vm.overcommit_memory=1` in shell.


`Error: Os { code: 98, kind: AddrInUse, message: "Address already in use" }`
Solution: delete the socket file in your local .socket file with `rm -f <filename>`



## Portals and Connections:

- Urbit NockChain group?
- how do I optimize the prover?
- i cant list my notes on nockchain-wallet?


### Start up Script for 3 Nodes:

#### start_nodes.sh

#Note: Run vm_overload command before you do this!
```sh
#!/bin/bash

read -p "Did you run 'sudo sysctl -w vm.overcommit_memory=1' before starting? [Y/N] " answer
case "$answer" in
  [Yy]* ) echo "Starting nodes...";;
  * ) echo "Please run 'sudo sysctl -w vm.overcommit_memory=1' first. Exiting."; exit 1;;
esac

ROOT_DIR="/nockchain"
START_CORE=0
CORES_PER_NODE=2
TOTAL_NODES=3
NODE_PREFIX="n"

for i in $(seq 1 $TOTAL_NODES); do
  NODE_DIR="${ROOT_DIR}/${NODE_PREFIX}${i}"
  ENV_FILE="${NODE_DIR}/.env"
  LOG_FILE="${NODE_DIR}/node.log"
  SOCKET_PORT=$((8000 + i))

  CORE_START=$START_CORE
  CORE_END=$((START_CORE + CORES_PER_NODE -1))
  CPU_RANGE="${CORE_START}-${CORE_END}"

  if [ -f "$ENV_FILE" ]; then
    echo "Starting node $NODE_DIR on cores $CPU_RANGE with UDP port $SOCKET_PORT..."

    # Load environment variables from .env
    ( set -a
    source "$ENV_FILE"
    set +a

    # Export vars that run_mod.sh would have exported explicitly
    export RUST_LOG
    export MINIMAL_LOG_FORMAT
    export MINING_PUBKEY

    # Launch the nockchain process with the right parameters, CPU affinity, logging output
    taskset -c "$CPU_RANGE" nockchain \
      --mining-pubkey "${MINING_PUBKEY}" \
      --mine \
      --bind "/ip4/0.0.0.0/udp/${SOCKET_PORT}/quic-v1" \
      >> "$LOG_FILE" 2>&1 &
    ) &
    START_CORE=$((START_CORE + CORES_PER_NODE))
  else
    echo "Environment file $ENV_FILE missing, skipping node $NODE_DIR"
  fi
done

```

### stop_nodes.sh
```sh
#!/bin/bash

ROOT_DIR="root/nockchain"
NODE_PREFIX="n"
TOTAL_NODES=3
SOCKET_FILENAME="nockchain_npc.sock"

echo "Stopping all nockchain nodes under $ROOT_DIR..."

for i in $(seq 1 $TOTAL_NODES); do
  NODE_DIR="$ROOT_DIR/${NODE_PREFIX}${i}"
  SOCKET_DIR="${NODE_DIR}/.socket"
  SOCKET_PATH="${SOCKET_DIR}/${SOCKET_FILENAME}"

  if [ -d "$NODE_DIR" ]; then

    # Delete socket file if it exists
    if [ -f "$SOCKET_PATH" ]; then
      echo "Deleting socket file $SOCKET_PATH"
      rm -f "$SOCKET_PATH"
    else
      echo "Socket file $SOCKET_PATH not found, skipping delete."
    fi

    # Get PIDs of nockchain processes launched from within this node directory
    PIDS=$(pgrep -f "nockchain.*${NODE_DIR}")

    if [ -n "$PIDS" ]; then
      echo "Killing nockchain in $NODE_DIR (PIDs: $PIDS)"
      kill $PIDS
    else
      echo "No nockchain process found for $NODE_DIR"
    fi

  else
    echo "Node directory $NODE_DIR not found, skipping."
  fi
done
```

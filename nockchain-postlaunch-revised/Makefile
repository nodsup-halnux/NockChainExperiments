# Load environment variables from .env file
include .env

# Set default env variables if not set in .env
# =? is conditional assignment, only if var is not set.
export RUST_BACKTRACE ?= full  # Enables full backtrace on Rust panics
export RUST_LOG ?= info,nockchain=info,nockchain_libp2p_io=info,libp2p=info,libp2p_quic=info  # Configures log levels
export MINIMAL_LOG_FORMAT ?= true  # Activates minimal log formatting
export MINING_PUBKEY ?= 2qwq9dQRZfpFx8BDicghpMRnYGKZsZGxxhh9m362pzpM9aeo276pR1yHZPS41y3CW3vPKxeYM8p8fzZS8GXmDGzmNNCnVNekjrSYogqfEFMqwhHh5iCjaKPaDTwhupWqiXj6  # Default mining key
export  # Ensures all above variables are inherited by child processes

.PHONY: build  # Declares 'build' as a non-file target
#for phony build tag, run build-hoon-all and build rust.
build: build-hoon-all build-rust
	# Displays environment variables
	$(call show_env_vars)  

# Compiles all Rust crates in optimized mode
.PHONY: build-rust
build-rust:
	cargo build --release  

.PHONY: test
test:
	cargo test --release  # Executes all tests with release optimizations

# Installs hoonc from local path
.PHONY: install-hoonc
install-hoonc: nuke-hoonc-data  # Pre-cleaning required data before install
	$(call show_env_vars)
	cargo install --locked --force --path crates/hoonc --bin hoonc  

 # Updates hoonc without removing previous data
.PHONY: update-hoonc
update-hoonc:
	$(call show_env_vars)
	cargo install --locked --path crates/hoonc --bin hoonc 

.PHONY: install-nockchain
install-nockchain: build-hoon-all  # Builds hoon assets prior to install
	$(call show_env_vars)
	cargo install --locked --force --path crates/nockchain --bin nockchain

.PHONY: update-nockchain
update-nockchain: build-hoon-all
	$(call show_env_vars)
	cargo install --locked --path crates/nockchain --bin nockchain

.PHONY: install-nockchain-wallet
install-nockchain-wallet: build-hoon-all
	$(call show_env_vars)
	cargo install --locked --force --path crates/nockchain-wallet --bin nockchain-wallet

.PHONY: update-nockchain-wallet
update-nockchain-wallet: build-hoon-all
	$(call show_env_vars)
	cargo install --locked --path crates/nockchain-wallet --bin nockchain-wallet

.PHONY: ensure-dirs
ensure-dirs:
	mkdir -p hoon  # Ensures 'hoon' directory exists
	mkdir -p assets  # Ensures 'assets' directory exists

.PHONY: build-trivial
build-trivial: ensure-dirs
	$(call show_env_vars)
	echo '%trivial' > hoon/trivial.hoon  # Writes a test Hoon file
	hoonc --arbitrary hoon/trivial.hoon  # Compiles the test file

HOON_TARGETS=assets/dumb.jam assets/wal.jam assets/miner.jam  # Defines Hoon output targets

.PHONY: nuke-hoonc-data
nuke-hoonc-data:
	rm -rf .data.hoonc  # Removes local hoonc cache
	rm -rf ~/.nockapp/hoonc  # Removes user hoonc data

.PHONY: nuke-assets
nuke-assets:
	rm -f assets/*.jam  # Deletes all jam files

.PHONY: build-hoon-all
build-hoon-all: nuke-assets update-hoonc ensure-dirs build-trivial $(HOON_TARGETS)
	$(call show_env_vars)  # Executes full hoon asset pipeline

.PHONY: build-hoon
build-hoon: ensure-dirs update-hoonc $(HOON_TARGETS)
	$(call show_env_vars)  # Variant of build-hoon-all without cleaning

.PHONY: run-nockchain
run-nockchain:
	$(call show_env_vars)
	mkdir -p miner-node && cd miner-node && rm -f nockchain.sock && RUST_BACKTRACE=1 cargo run --release --bin nockchain -- --npc-socket nockchain.sock --mining-pubkey $(MINING_PUBKEY) --mine  # Launches node with mining

# Dynamically discovers all hoon source files
HOON_SRCS := $(find hoon -type file -name '*.hoon')  

 # Compiles dumbnet outer.hoon with tracing
assets/dumb.jam: update-hoonc hoon/apps/dumbnet/outer.hoon $(HOON_SRCS)
	$(call show_env_vars)
	RUST_LOG=trace hoonc hoon/apps/dumbnet/outer.hoon hoon 
	mv out.jam assets/dumb.jam  # Moves output to assets

assets/wal.jam: update-hoonc hoon/apps/wallet/wallet.hoon $(HOON_SRCS)
	$(call show_env_vars)
	RUST_LOG=trace hoonc hoon/apps/wallet/wallet.hoon hoon
	mv out.jam assets/wal.jam

assets/miner.jam: update-hoonc hoon/apps/dumbnet/miner.hoon $(HOON_SRCS)
	$(call show_env_vars)
	RUST_LOG=trace hoonc hoon/apps/dumbnet/miner.hoon hoon
	mv out.jam assets/miner.jam

## Code Deep-Dive:


## Reminder: What Runes Do:
- `/= face file` Fas-Tis: import and build a hoon file.
- `^- aura noun` Ket-Hep: Type cast by explicit label type. Put at the top of every gate and trap, for compiler hints.
- `%*` centar: 
- `|* samp output` bartar : Produce a wet gate
- `=> subject arg` tisgal: compose two expressions
- `|~ a b` barsig: produce an Iron gate
- `=,` expose a namespace.


### TODO:
    - try adding your own hoon file as a dependency. Can you get it to compile in inner.hoon?

### Perusing the Comment Summary Files:

Directory Structure:

'''
/nockchain
├── /crates                          ── Rust Libraries
└── /hoon
    ├── /apps
    │   ├── /dumbnet                   
    │   │   └── /lib                 
    │   └── /wallet                   
    ├── /common                       
    │   ├── /stark                   
    │   ├── /table                  
    │   │   ├── /prover               
    │   │   └── /verifier            
    │   └── /ztd                    
    └── /dat                        
'''
Every folder and subfolder has a special .comments file, which all the comments for .hoon files at that level are aggregated (some files are thousands of lines, so this helps).

### Make file Dependencies:

Before you compile any hoon, you must first generate the hoonc.jam binary, which is done by running `make install-hoonc`
The make file has the following dependencies, when a particular .PHONY target is run:

```
build
├── build-hoon-all
│   ├── nuke-assets
│   ├── update-hoonc
│   ├── ensure-dirs
│   ├── build-trivial
│   ├── assets/dumb.jam
│   ├── assets/wal.jam
│   └── assets/miner.jam
├── build-rust
│   └── cargo build --release

build-hoon
├── ensure-dirs
├── update-hoonc
├── assets/dumb.jam
├── assets/wal.jam
└── assets/miner.jam

assets/dumb.jam
├── update-hoonc
├── hoon/apps/dumbnet/outer.hoon
└── $(HOON_SRCS) — all .hoon files (dependency tracking only)

assets/wal.jam
├── update-hoonc
├── hoon/apps/wallet/wallet.hoon
└── $(HOON_SRCS)

assets/miner.jam
├── update-hoonc
├── hoon/apps/dumbnet/miner.hoon
└── $(HOON_SRCS)

install-hoonc
├── nuke-hoonc-data
└── cargo install --path crates/hoonc --bin hoonc

install-nockchain
├── build-hoon-all
└── cargo install --path crates/nockchain --bin nockchain

install-nockchain-wallet
├── build-hoon-all
└── cargo install --path crates/nockchain-wallet --bin nockchain-wallet

run-nockchain
└── cargo run --bin nockchain with runtime options

test
└── cargo test --release
```

- when you do a git pull to update the code base from remote, you need to: 
```sh
git fetch
git diff <...don clobber your own code!...>
git merge <...carefully...>
rsync to server
#On Server:
make build
#hoon-build all has already been run
make install-nockchain-lite
make install-nockchain-wallet-lite
```
- if rust is not changed, just rebuild the jam files with `make build hoon`
    - there are three jam files: `miner.jam, wal.jam and dumb.jam`. They are placed in a newly made `/assets` folder.
        - **How it works:** For each file (hoon/apps/dumbnet/miner.hoon, hoon/apps/dumbnet/outer.hoon, hoon/apps/wallet/wallet.hoon), a list of all hoon files in the /hoon directory $(HOON_SRC) is fed into the rust package hoonc.
        - the rust crates have .rs wrappers that load them in.
        - so nockchain/wallet is scaffoled by rust on the outside, and has raw hoon jams in the inside for running code.
        - It gathers all the relevent hoon files from the list, and compiles one big jam file.
    - jam files are static compiled code, and are fed in as inputs to all the rust libraries (???).

- Q: are there temporary compile directories for hoon?
    -A: No. All the hoon files get recompiled and slammed into a jam, with hoonc.
- Q: are there temporary compile directories for rust?
    - A:??





### Observations from the Mermaid Graph:

- Our miner is mainly centered around the /dumbnet folder.
- /dat and /markdown don't appear to be that important.
- The actual state file is eight.hoon, which the most used file (/common/zeke) imports and renames.
    - nearly every file uses zeke.hoon!
- for the /common files, they are imported into the /lib files of /dumbnet.
- inner.hoon aggregates everything, and has over 20 imports.
- outer.hoon wraps inner.hoon, and acts as a kernel core somehow??

### Code Questions:

*Q: How does outer miner.hoon differ from the inner /lib/miner.hoon?*
A: one is likey an import for the other. Its all controlled by inner.hoon in the end.


*Q: How are the components loaded into one another and bootstrapped? How does it all work?*
A: See the giant chart in /code_structure for now.


### Adjusting the Make file (for faster compilation):

We need the following to be able to develop effectively:

### (1) The ability to download code patches and pullrequests, for our file structure.

#### Official code updates:

This is easily remedied by cloning the repo, and keeping the .git folder separate from our
outer git folder. Just run the following commands:

```sh

git clone https://github.com/zorp-corp/nockchain.git
git fetch
git diff HEAD origin/main
#Or this if you just want the latest changes.
git pull
#recompiles everything, and sets it back up
make install-nockchain
```

Remember to adjust the top level .gitignore, to avoid `**/nockchain`. If the inner .git folder is detected, you will end up with a git module and a headache to revert the remote.

### Installing specific PR Branches.

You need to have separate folders for the branches, and juggle the.



### (2) Being able to upload code changes to our server, using sftp.

For simplicity we use the root account with no special restrictions (you must be very careful doing this).  To minimze file transfers, we use rsync command to only update the files. 

Naturally, rsync only updates newer files, and ignores files that stay the same.

```sh
#check to be sure first (verbose output):
rsync -avz --dry-run ./nockchain/ root@<host>:/root/nockchain/

#main command to execute.
rsync -avz ./nockchain/ root@<host>:/root/nockchain/

```

TODO:
- Sync codebase with single droplet. recompile all [X]
    - test a node. do they run?? is env file ok? [X]
- test rsync for single [X], 



2) The ability to only compile the hoon files we add or change. NOT to recompile the entire code base.
    => recompiling everything from scratch takes 30 minutes (!!).  

Firstly, I cannot adequately run the miner on my development machine (32Gb ram, won't risk vm_overcommit).
So all files must be pushed to the server to be run, and compiled there individually.


### Getting Ready to mine:

#### Syncing to tip: 

We need to have all of our nodes synced to tip. The best strategy is to go on the forums and find a state.jam file. Note: Don't use curl - it will garble the data. Use a browser, and rsync it to your VPS. If the file is less 500mb, it is of no use.  To send to VPS server:

```sh

#shows progress so you are not left hanging
rsync -avz --progress  ./statejams/jamfile root@<ip>/root/nockchain/blockjumps
#check file - should say "data"
file /blockjumps/state.jam

```

Use the sync_nodes.sh script to run the miner nodes without the --mine option (much faster).
Config for a syncing node only - vars defined in sync_nodes.sh.

```sh
  nohup nockchain \
      --mining-pubkey "${MINING_PUBKEY}" \
      --state-jam "${SJ_PATH}/state${J_NUM}.jam" \
      --peer /dnsaddr/nockchain-backbone.zorp.io \
      --bind "/ip4/0.0.0.0/udp/${SOCKET_PORT}/quic-v1" \
      >> "$LOG_FILE" 2>&1 &

```

**Even with a jam file that is close to the block tip, you may need to run your nodes for a while (1hr+) before they get to the block tip.**

Looking at node logs, these are the most common messages we get. Lots of cross-talk (and not enough block syncing). Lets investigate some messages for one of the syncing nodes on my VPS: Script: logs_search.sh is used to gather data from the logs:

0) Any line that has the word "block" in it:
    - Percentage Occurance: 0.03%
    - Not enough!

1) "[0m: IP address 173.231.60.162 exceeded the request-per-interval threshold with 93 requests"
    - Percentage Occurance:  10.80%
    - Origin: libp2p.io
    - What does it mean: You set a timeout for all peers. If they make too many requests in an interval, your node blocks them for a period of time.

2) "Error making request to peer 12D3KooWGogMNgAAmy9quCrUnKAPNJpreAXGd3qqduyPUgX1HigM: Eof { name: "enum", expect: Small(1) }"
    - Percentage Occurance:  2.56%
    - What does it mean: This hardcoded peer is dead

3) "Failed to dial address /ip4/60.29.93.218/udp/20182/quic-v1/p2p/12D3KooWL5EXN7Sko9xoUtypuUXktPw2"
    - Percentage Occurance:  3.10%
    - What does it mean: hardcoded peer is dead.

4) "SEvent: friendship ended with 12D3KooWCWrQUzziDH7aaiJUn5ntptLDpxj9JRKvRhfbm8LEg3vg via"
    - Percentage Occurance:  0.02%
    - What does it mean: hardcorded peer is dead.

5) "Removing peer: 12D3KooWGVh5rnRCbEoFvPsGUSyTVZXBbvGCi2XCbs71XjswAWhB"
    - Percentage Occurance:  0.02%
    - What does it mean: hardcoded peer is dead...

A lot of these lines come from a hand-coded peers that don't seem to function. For the rest, its just config.rs settings in the `./crates/nock-chain-libp2p-io/config.js`


Some potential settings to change:

```Rust
/** How often we should run a kademlia bootstrap to keep our peer table fresh */
const KADEMLIA_BOOTSTRAP_INTERVAL: Duration = Duration::from_secs(300);
/** How long we should keep a peer connection alive with no traffic */
const SWARM_IDLE_TIMEOUT: Duration = Duration::from_secs(60); //30

const INITIAL_PEER_RETRIES: u32 = 8; //5

const KEEP_ALIVE_INTERVAL: Duration = Duration::from_secs(30); //15

const HANDSHAKE_TIMEOUT: Duration = Duration::from_secs(10); //15

const IDENTIFY_INTERVAL: Duration = KADEMLIA_BOOTSTRAP_INTERVAL;

/** Maximum number of established *incoming* connections */
const MAX_ESTABLISHED_INCOMING_CONNECTIONS: u32 = 20; //32

/** Maximum number of established *incoming* connections */
const MAX_ESTABLISHED_OUTGOING_CONNECTIONS: u32 = 40; //16

/** Maximum number of established connections */
const MAX_ESTABLISHED_CONNECTIONS: u32 = 60; //48

/** Maximum number of established connections with a single peer ID */
const MAX_ESTABLISHED_CONNECTIONS_PER_PEER: u32 = 10; //2

/** Maximum pending incoming connections */
const MAX_PENDING_INCOMING_CONNECTIONS: u32 = 32; //16

/** Maximum pending outcoing connections */
const MAX_PENDING_OUTGOING_CONNECTIONS: u32 = 32; //16

const REQUEST_HIGH_THRESHOLD: u64 = 90; //60
const REQUEST_HIGH_RESET: Duration = Duration::from_secs(30); //60

const PEER_STORE_RECORD_CAPACITY: usize = 30 * 1024; //10


```
These setting changes allow for less error messages, and more connections and syncing. We are more lenient and sociable, overall. **The general idea is that we need to be able to sync our blocks quickly - I can't afford to run the VPS 24/7, as it will cost too much. Having a strategy to sync blocks quickly, is imperative.**

**Another Issue:** our sync_nodes.sh script uses a statejam. But after we have synced, it will continue using the old statejam and start again! Need to optionally use a statejam for this script.

**Q: How do we confirm we are at blockchain tip?**
A: Use the check_chaintip.sh script. It will report the last "validated block" line it sees from the node.logs file. Cross reference with [status.nockchain.io](https://status.nockchain.io)


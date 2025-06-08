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

- Building Code:
    - how to I compile individual hoon files?
    - do I do desk devleopment? Or is hoonc somehow used?
    - what are the inert jam files used for (raw Hoon code in C??)
    - how does Rust fit into all this? How are those components compiled?


### Perusing the Comment Summary Files:

Directory Structure:

'''
/nockchain
├── /crates                          ── Rust Libraries
└── /hoon
    ├── /apps
    │   ├── /dumbnet                ── dumbnet comments
    │   │   └── /lib                ── comments
    │   └── /wallet                 ── comments
    ├── /common                     ── common comments
    │   ├── /stark                  ── comments
    │   ├── /table                  ── table comments
    │   │   ├── /prover             ── comments
    │   │   └── /verifier           ── comments
    │   └── /ztd                    ── comments
    └── /dat                        ── comments
'''

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
A: 


*Q: How are the components loaded into one another and bootstrapped? How does it all work?*
A: See the giant chart in /code_structure for now.


### Adjusting the Make file (for faster compilation):

We need the following to be able to develop effectively:

### (1) The ability to download code patches and pullrequests, for our file structure.

This is easily remedied by cloning the repo, and keeping the .git folder separate from our
outer git folder. Just run the following commands:

```sh

git clone https://github.com/zorp-corp/nockchain.git
git fetch
git diff HEAD origin/main
#Or this if you just want the latest changes.
git pull
```

Remember to adjust the top level .gitignore, to avoid `**/nockchain-`


2) The ability to only compile the hoon files we add or change. NOT to recompile the entire code base.
    => recompiling everything from scratch takes 30 minutes (!!).

Firstly, I cannot adequately run the miner on my development machine (32Gb ram, won't risk vm_overcommit).
So all files must be pushed to the server to be run. SFTP must be used to push the files to the Droplet.




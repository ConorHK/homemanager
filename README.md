# homemanager
nix homemanager setup

## Bootstrap instructions
### Prerequisites
* Nix installed with enough space for a big nix dir.

### Steps
0. Clone repo
1. Enter shell via:
    * `nix-shell`
    * `nix --extra-experimental-features 'nix-command flakes' develop`

2. Activate the config
```
nh home switch .
```

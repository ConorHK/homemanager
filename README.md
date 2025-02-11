# homemanager
nix homemanager setup

## Bootstrap instructions
### Prerequisites
* Nix installed with enough space for a big nix dir.

### Steps
0. Clone repo
1. Initialize Home Manager
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update
```

2. Activate the config
```
noglob home-manager switch --flake .#<role> --extra-experimental-features 'nix-command flakes'
```

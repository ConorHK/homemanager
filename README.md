# homemanager
nix homemanager setup

## Bootstrap instructions
### Prerequisites
* Nix installed with enough space for a big nix dir.

### Steps
0. Clone repo
1. Initialize Home Manager
```
nix --extra-experimental-features "nix-command flakes" run home-manager/master --init
```

2. Activate the config
```
home-manager switch --flake .#<role> --extra-experimental-features 'nix-command flakes'
```

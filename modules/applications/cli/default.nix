{ lib, ... }:

with lib;
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./cnvim.nix
    ./comma.nix
    ./duf.nix
    ./dust.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./htop.nix
    ./jq.nix
    ./less.nix
    ./networking-tools.nix
    ./nix-your-shell.nix
    ./ripgrep.nix
    ./script-directory.nix
    ./ssh.nix
    ./tmux.nix
    ./wget.nix
    ./zoxide.nix
    ./zsh.nix
  ];
}

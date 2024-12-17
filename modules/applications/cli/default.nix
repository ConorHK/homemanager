{lib, ...}:

with lib;
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./cnvim.nix
    ./dust.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./jq.nix
    ./less.nix
    ./ripgrep.nix
    ./ssh.nix
    ./tmux.nix
    ./wget.nix
    ./zoxide.nix
    ./zsh.nix
  ];
}

{
  config,
  inputs,
  lib,
  pkgs,
  specialArgs,
  ...
}:

let
  if-exists = f: builtins.pathExists f;
  existing-imports = imports: builtins.filter if-exists imports;
  inherit (specialArgs) username;
in
with lib;
{
  imports =
    [
      ./homemanager.nix
      ./locale.nix
      ./nix.nix
    ]
    ++ existing-imports [
      ./users/${username}
      ./users/${username}.nix
    ];

  host = {
    home = {
      applications = {
        atuin.enable = mkDefault true;
        bat.enable = mkDefault true;
        cnvim.enable = mkDefault true;
        comma.enable = mkDefault true;
        duf.enable = mkDefault true;
        dust.enable = mkDefault true;
        eza.enable = mkDefault true;
        fzf.enable = mkDefault true;
        htop.enable = mkDefault true;
        jq.enable = mkDefault true;
        less.enable = mkDefault true;
        networking-tools.enable = mkDefault true;
        nix-your-shell.enable = mkDefault true;
        python.enable = mkDefault true;
        ripgrep.enable = mkDefault true;
        script-directory.enable = mkDefault true;
        tmux.enable = mkDefault true;
        wget.enable = mkDefault true;
        zoxide.enable = mkDefault true;
        zsh.enable = mkDefault true;
        git = {
          enable = mkDefault true;
          defaultBranch = mkDefault "main";
          email = mkDefault "foo";
        };
      };
    };
  };

  home = {
    packages =
      with pkgs;
      (lib.optionals pkgs.stdenv.isLinux [
        psmisc
        strace
      ]);
  };
}

{
  inputs,
  config,
  flake,
  lib,
  pkgs,
  ...
}:
with lib;
{
  home.sessionVariables = {
    EDITOR = "vim";
  };

  nix = {
    settings = {
      auto-optimise-store = mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = mkDefault true;
      warn-dirty = mkDefault false;
      trusted-users = [ config.home.username ];
    };

    package = pkgs.nixVersions.stable;
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  };

  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [ home-manager ];

  cli = {
    shells.zsh.enable = true;
    programs = {
      bat.enable = true;
      btop.enable = true;
      comma.enable = true;
      duf.enable = true;
      dust.enable = true;
      eza.enable = true;
      fzf.enable = true;
      less.enable = true;
      nh.enable = true;
      ssh.enable = mkDefault true;
      zoxide.enable = true;
    };
  };
  imports = [
    flake.homeModules.cli
  ];
}

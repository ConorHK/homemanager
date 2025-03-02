{
  flake,
  lib,
  pkgs,
  ...
}:
with lib;
{
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

{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.duf;
in
  with lib;
{
  options = {
    host.home.applications.duf = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "'df' command line replacement";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ duf ];
    programs.zsh.shellAliases = { df = "duf"; };
  };
}

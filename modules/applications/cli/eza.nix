{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.applications.eza;
in
with lib;
{
  options = {
    host.home.applications.eza = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "'ls' command line replacement";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      eza.enable = true;
      zsh.shellAliases = {
        l = "eza -la";
        ls = "eza";
      };
    };
  };
}

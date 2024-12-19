{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.applications.nix-your-shell;
in
with lib;
{
  options = {
    host.home.applications.nix-your-shell = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wrapper for nix-develop";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nix-your-shell.enable = true;
  };
}

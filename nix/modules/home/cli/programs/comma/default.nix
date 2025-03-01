{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.comma;
in
{
  options.cli.programs.comma = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable comma which run applications not already installed on system";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-index
      comma
    ];
  };
}

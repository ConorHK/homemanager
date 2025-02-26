{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.nix-your-shell;
in
{
  options.cli.programs.nix-your-shell = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable wrapper for nix-develop";
    };
  };

  config = mkIf cfg.enable {
    programs.nix-your-shell.enable = true;
  };
}

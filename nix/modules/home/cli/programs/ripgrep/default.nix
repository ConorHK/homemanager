{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.cli.programs.ripgrep;
in
{
  options.cli.programs.ripgrep = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable better grep";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      ripgrep = {
        enable = true;
      };
    };
  };
}

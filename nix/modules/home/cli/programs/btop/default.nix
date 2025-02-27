{
  config,
  lib,
  ...
}:
let
  cfg = config.cli.programs.btop;
in
with lib;
{
  options.cli.programs.btop = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Process monitor";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      btop = {
        enable = true;
      };
    };
  };
}

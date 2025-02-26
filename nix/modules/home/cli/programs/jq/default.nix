{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.jq;
in
{
  options.cli.programs.jq = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable json parser";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      jq = {
        enable = true;
      };
    };
  };
}

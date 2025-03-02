{
  config,
  lib,
  ...
}:
let
  cfg = config.desktop.programs.firefox;
in
with lib;
{
  options.desktop.programs.firefox = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable firefox";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
      };
    };
  };
}

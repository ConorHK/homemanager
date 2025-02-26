{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.zoxide;
in
{
  options.cli.programs.zoxide = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable directory traversal assistant";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}

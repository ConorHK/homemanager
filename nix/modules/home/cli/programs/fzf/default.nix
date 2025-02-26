{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.cli.programs.fzf;
in
{
  options.cli.programs.fzf = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable fuzzy Finder";
    };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      fileWidgetOptions = [
        "--preview 'head {}'"
      ];
      historyWidgetOptions = [
        "--sort"
      ];
    };
  };
}

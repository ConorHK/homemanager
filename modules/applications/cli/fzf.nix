{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.applications.fzf;
in
with lib;
{
  options = {
    host.home.applications.fzf = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Fuzzy Finder";
      };
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

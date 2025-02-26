{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.cli.programs.less;
in
{
  options.cli.programs.less = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable pager";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      less = {
        enable = true;
      };
      zsh = {
        sessionVariables = {
          LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
        };
      };
    };
  };
}

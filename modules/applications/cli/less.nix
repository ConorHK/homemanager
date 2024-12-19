{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.applications.less;
in
with lib;
{
  options = {
    host.home.applications.less = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Pager";
      };
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

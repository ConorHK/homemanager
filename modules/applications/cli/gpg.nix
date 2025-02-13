{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.applications.gpg;
in
with lib;
{
  options = {
    host.home.applications.gpg = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gnu Privacy Guard";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      gpg.enable = true;
    };
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}


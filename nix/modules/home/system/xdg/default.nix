{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.xdg;
in
{
  options.system.xdg = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable xdg directories";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GTK2_RC_FILES = lib.mkForce "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";
      userDirs = {
        enable = true;
        createDirectories = true;

        desktop = "${config.home.homeDirectory}/desktop";
        documents = "${config.home.homeDirectory}/docs";
        download = "${config.home.homeDirectory}/dl";
        music = "${config.home.homeDirectory}/media/music";
        pictures = "${config.home.homeDirectory}/media/pictures";
        publicShare = null;
        templates = null;
        videos = "${config.home.homeDirectory}/media/vidoes";

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
          XDG_REPOSITORIES_DIR = "${config.home.homeDirectory}/repositories";
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.gnome;
in
{
  options.desktop.environment.gnome = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable GNOME desktop environment";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    ];

    xdg = {
      mime.enable = true;
      systemDirs.data = [
        "${config.home.homeDirectory}/.nix-profile/share/applications"
        "${config.home.homeDirectory}/state/nix/profile/share/applications"
      ];
    };
    targets.genericLinux.enable = true;
    dconf.settings = {
      "org/gnome/shell" = {
        favourite-apps = [
          "firefox.desktop"
          "alacritty.desktop"
        ];
      };
    };
  };
}

{
  flake,
  pkgs,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
    programs = {
      alacritty.enable = true;
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    LIBSEAT_BACKEND = "logind";
  };

  home.packages = with pkgs; [
  ];

  imports = [
    flake.homeModules.desktop
  ];
}

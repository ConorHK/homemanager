{
  flake,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
    programs = {
      alacritty.enable = true;
      firefox.enable = true;
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

  imports = [
    flake.homeModules.desktop
  ];
}

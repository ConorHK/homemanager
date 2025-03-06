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
      gnome-tweaks
      gnomeExtensions.search-light
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
        disable-user-extensions = false;
        enabled-extensions = [
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          "search-light@icedman.github.com"
        ];
        favourite-apps = [
          "firefox.desktop"
          "Alacritty.desktop"
        ] ++ optional config.desktop.programs.discord.enable "discord.desktop";
      };
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Shift><Super>q" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "alacritty";
        name = "Open terminal";
      };
      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
      };
      "org/gnome/shell/extensions/search-light" = {
        shortcut-search = [ "<Super>Space" ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
      };
      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    };
  };
}

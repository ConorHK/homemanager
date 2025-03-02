{
  config,
  lib,
  ...
}:
let
  cfg = config.desktop.programs.alacritty;
  creeperEnabled = config.system.fonts.creeper.enable;
in
with lib;
{
  options.desktop.programs.alacritty = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable alacritty terminal emulator";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          window = {
            padding = {
              x = 5;
              y = 5;
            };
            decorations_theme_variant = "Dark";
          };
          # colors = {
          #   primary = {
          #     background = "#1c1c1c";
          #     foreground = "#dfdfaf";
          #   };
          #   cursor = {
          #     text = "#191919";
          #     cursor = "#dfdfaf";
          #   };
          #   normal = {
          #     black = "#262626";
          #     red = "#af5f5f";
          #     green = "#87875f";
          #     yellow = "#af875f";
          #     blue = "#878787";
          #     magenta = "#af8787";
          #     cyan = "#87afaf";
          #     white = "#dfdfaf";
          #   };
          #   bright = {
          #     black = "#626262";
          #     red = "#af5f5f";
          #     green = "#87875f";
          #     yellow = "#af875f";
          #     blue = "#878787";
          #     magenta = "#af8787";
          #     cyan = "#87afaf";
          #     white = "#dfdfaf";
          #   };
          # };
          cursor = {
            style = "block";
            unfocused_hollow = true;
          };
          font = mkIf creeperEnabled {
            normal = {
              family = "creeper";
              style = "Regular";
            };
            size = 16;
          };
        };
      };
    };
  };
}

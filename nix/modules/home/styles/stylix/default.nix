{
  lib,
  pkgs,
  config,
  inputs,
  perSystem,
  ...
}:
let
  cfg = config.styles.stylix;
in
with lib;
{
  imports = with inputs; [
    stylix.homeManagerModules.stylix
  ];

  options.styles.stylix = {
    enableTerminal = mkOption {
      default = false;
      type = with types; bool;
      description = "enable stylix for terminal";
    };
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable stylix for all";
    };
  };

  config =
    mkIf cfg.enableTerminal {
      stylix =
        {
          enable = true;
          autoEnable = true;
          base16Scheme = {
            base00 = "#1c1c1c";
            base01 = "#262626";
            base02 = "#626262";
            base03 = "#878787";
            base04 = "#dfdfaf";
            base05 = "#dfdfaf";
            base06 = "#dfdfaf";
            base07 = "#dfdfaf";
            base08 = "#af5f5f";
            base09 = "#af875f";
            base0A = "#af875f";
            base0B = "#87875f";
            base0C = "#87afaf";
            base0D = "#878787";
            base0E = "#af8787";
            base0F = "#87afaf";
          };
        }
        ++ attrsets.optionalAttrs cfg.enable {
          image = config.lib.stylix.pixel "base00";
          cursor = {
            name = "Quintom_Ink";
            package = pkgs.quintom-cursor-theme;
            size = 20;
          };

          fonts = {
            sizes = {
              terminal = 10;
              applications = 12;
              popups = 12;
            };

            serif = {
              name = "Noto Serif";
              package = pkgs.noto-fonts;
            };

            sansSerif = {
              name = "Noto Sans";
              package = pkgs.noto-fonts;
            };

            monospace = {
              package = perSystem.self.creeper;
              name = "Creeper";
            };

            emoji = {
              package = pkgs.noto-fonts-emoji;
              name = "Noto Color Emoji";
            };
          };
        };
    }
    ++ attrsets.optionalAttrs cfg.enable {
      fonts.fontconfig.enable = true;
    };
}

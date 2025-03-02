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
    stylix.nixosModules.stylix
  ];

  options.styles.stylix = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable stylix";
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    environment.systemPackages = with pkgs; [
      nerd-fonts.symbols-only
      open-sans
    ];

    stylix = {
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
      # targets = {
      #   firefox = {
      #     firefoxGnomeTheme.enable = true;
      #     profileNames = ["Default"];
      #   };
      # };
      #
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
  };
}

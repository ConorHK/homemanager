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
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable stylix for all";
    };
  };

  config =
    mkIf cfg.enable {
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
        };
    };
}

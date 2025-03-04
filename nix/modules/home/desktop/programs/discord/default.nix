{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.discord;
in {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  options.desktop.programs.discord = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable discord voicechat";
    };
  };

  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
    };
  };
}

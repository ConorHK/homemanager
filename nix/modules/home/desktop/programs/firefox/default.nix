{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.desktop.programs.firefox;
in
with lib;
{
  imports = [
    inputs.schizofox.homeManagerModules.default
  ];

  options.desktop.programs.firefox = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable firefox";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      schizofox = {
        enable = true;

        # theme = {
        #   colors = {
        #     background-darker = config.styli
        #   };
        # };
      };
    };
  };
}

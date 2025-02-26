{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cli.programs.duf;
in {
  options.cli.programs.duf = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable 'df' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [duf];
    programs.zsh.shellAliases = {
      df = "duf";
    };
  };
}

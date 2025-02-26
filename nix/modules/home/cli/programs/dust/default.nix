{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.dust;
in
{
  options.cli.programs.dust = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable 'du' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      du-dust
    ];
    programs = {
      zsh.shellAliases = {
        du = "dust";
      };
    };
  };
}

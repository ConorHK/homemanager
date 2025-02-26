{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.cli.programs.eza;
in
{
  options.cli.programs.eza = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable 'ls' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      eza.enable = true;
      zsh.shellAliases = {
        l = "eza -la";
        ls = "eza";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.wget;
in
{
  options.cli.programs.wget = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable remote file downloader";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        wget
      ];
    };
    programs = {
      zsh = {
        shellAliases = {
          wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts"; # Send history to a sane area
        };
      };
    };
  };
}

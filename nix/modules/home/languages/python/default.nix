{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.host.home.languages.python;
in
with lib;
{
  options = {
    host.home.applications.python = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Python programming language with dependencies";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (python312.withPackages (ppkgs: [
        ppkgs.ipdb
      ]))
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages.python;
in
with lib;
{
  options.languages.python = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable python programming language with dependencies";
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

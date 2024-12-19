{
  config,
  inputs,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  cfg = config.host.home.applications.cnvim;
in
with lib;
{
  imports = [ inputs.cnvim.homeModule ];
  options = {
    host.home.applications.cnvim = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Custom nvim";
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "cnvim";

    cnvim = {
      enable = true;
      packageNames = [ "cnvim" ];
    };

    programs.zsh.shellAliases = {
      vim = "cnvim";
    };
  };
}

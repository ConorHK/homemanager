{ flake, lib, ... }:
with lib;
{
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
    flake.homeModules.work-role
  ];

  home = {
    sessionVariables = {
      HOSTROLE = "dev";
      BROWSER = "echo"; # print URLs
    };
    stateVersion = "25.05";
  };
  system.xdg.enable = true;

  # nixpkgs = {
  #   config = {
  #     allowUnfree = mkDefault true;
  #     allowUnfreePredicate = _: true;
  #   };
  # };
}

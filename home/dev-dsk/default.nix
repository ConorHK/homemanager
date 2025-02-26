{ lib, specialArgs, ... }:
let
  inherit (specialArgs) username;
in
with lib;
{
  home = {
    homeDirectory = "/home/${username}";
    sessionVariables = {
      HOSTROLE = "dev";
      BROWSER = "echo"; # print URLs
    };
  };
}

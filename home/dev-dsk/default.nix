{ lib, ... }:
with lib;
{
  home.sessionVariables = {
    HOSTROLE = "dev";
    BROWSER = "echo";  # print URLs
  };
}

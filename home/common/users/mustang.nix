{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  home.username = "mustang";
  home.homeDirectory = "/home/mustang";
}

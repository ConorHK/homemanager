{ config, lib, pkgs, ... }:
with lib;
{
  home.username = "conor";
  home.homeDirectory = "/home/conor";
}

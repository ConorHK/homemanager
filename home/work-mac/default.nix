{ lib, specialArgs, ... }:
let
  inherit (specialArgs) username;
in
with lib;
{
  nix.settings.use-xdg-base-directories = false;
  programs.zsh.history.path = "/Users/${username}/.zsh_history";
  home.homeDirectory = "/Users/${username}";
}

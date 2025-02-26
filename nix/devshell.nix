{ pkgs, perSystem }:
let
in
pkgs.mkShellNoCC {
  packages = [
    pkgs.home-manager
  ];
}

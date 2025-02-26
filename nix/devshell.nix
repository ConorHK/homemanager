{ pkgs }:
pkgs.mkShellNoCC {
  packages = [
    pkgs.home-manager
    pkgs.nh
  ];
}

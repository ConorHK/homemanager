{ config, inputs, lib, pkgs, specialArgs, ... }:

let
  if-exists = f: builtins.pathExists f;
  existing-imports = imports: builtins.filter if-exists imports;
  inherit (specialArgs) username;
in
with lib;
{
  imports = [
      ./homemanager.nix
      ./locale.nix
      ./nix.nix
    ]
    ++ existing-imports [
      ./users/${username}
      ./users/${username}.nix
    ];

    home = {
      packages = with pkgs;
        (lib.optionals pkgs.stdenv.isLinux
        [
          psmisc
          strace
        ]);
    };
}

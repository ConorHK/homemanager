{
  pkgs,
  inputs,
  ...
}:
inputs.treefmt-nix.lib.mkWrapper pkgs {
  projectRootFile = "flake.nix";

  settings.global.excludes = [
    "secrets/**"
    "**/*.toml"
  ];

  programs = {
    # Nix
    alejandra.enable = true;
    nixfmt-rfc-style.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}

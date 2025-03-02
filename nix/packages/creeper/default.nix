{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "creeper-bitmap";
  version = "1.0";
  src = ./fonts;

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r $src/*.otb $out/share/fonts/
  '';
}

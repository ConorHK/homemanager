{
  flake,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
  };

  hardware.audio.enable = true;
  styles.stylix.enable = true;

  imports = [
    flake.nixosModules.desktop
    flake.nixosModules.hardware
    flake.nixosModules.styles
  ];
}

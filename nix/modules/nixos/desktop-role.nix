{
  flake,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
  };

  hardware.audio.enable = true;

  imports = [
    flake.nixosModules.desktop
    flake.nixosModules.hardware
  ];
}

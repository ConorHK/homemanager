{
  flake,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
  };

  imports = [
    flake.nixosModules.desktop
  ];
}

{
  flake,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
    # programs = {
    # };
  };

  imports = [
    flake.nixosModules.desktop
  ];
}

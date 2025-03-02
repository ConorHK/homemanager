{
  flake,
  ...
}:
{
  imports = [
    flake.nixosModules.hardware
    flake.nixosModules.styles
    flake.nixosModules.system
    flake.nixosModules.user
  ];

  system = {
    nix.enable = true;
    boot.enable = true;
    locale.enable = true;
  };

  hardware.networking.enable = true;
  styles.stylix.enable = true;
}

{
  inputs,
  flake,
  ...
}:
{
  imports = [
    flake.nixosModules.hardware
    flake.nixosModules.security
    flake.nixosModules.styles
    flake.nixosModules.system
    flake.nixosModules.user
    inputs.nur.modules.nixos.default
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs.inputs = inputs;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  nixpkgs.config.allowUnfree = true;

  security = {
    sudo.wheelNeedsPassword = false;
    sops.enable = true;
  };

  system = {
    nix.enable = true;
    boot.enable = true;
    locale.enable = true;
    tailscale.enable = true;
  };

  hardware.networking.enable = true;
  styles.stylix.enableNixOs = true;
}

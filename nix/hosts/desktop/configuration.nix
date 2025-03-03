# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  flake,
  lib,
  pkgs,
  ...
}:

with lib;
{
  imports = [
    ./hardware-configuration.nix

    ./disks.nix
    inputs.disko.nixosModules.disko

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    flake.nixosModules.common-role
    flake.nixosModules.desktop-role
  ];

  hardware = {
    bluetooth = {
      enable = true;
    };
    logitechMouse.enable = true;
  };

  system.impermanence.enable = true;

  user = {
    name = "conor";
    extraOptions = {
      description = "Conor";
      uid = 1000;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
      allowUnfreePredicate = _: true;
    };
  };

  networking.hostName = "desktop";

  boot = {
    # TODO: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
    kernelParams = [
      # hibernate settings
      "resume_offset=533760"
    ];
    resumeDevice = "/dev/disk/by-label/nixos";

    supportedFilesystems = mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  system.stateVersion = "25.05";
}

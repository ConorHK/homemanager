# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, lib, pkgs, ... }:

with lib;
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disks.nix
      inputs.nixos-facter-modules.nixosModules.facter
      {config.facter.reportPath = ./facter.json;}
    ];

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };

  boot = {
    # TODO: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
    kernelParams = [  # hibernate settings
      "resume_offset=533760"
    ];
    resumeDevice = "/dev/disk/by-label/nixos";

    supportedFilesystems = mkForce ["btrfs"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  system.stateVersion = "25.05";
}

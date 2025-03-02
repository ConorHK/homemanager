# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, flake, lib, pkgs, ... }:

with lib;
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./disks.nix
      inputs.disko.nixosModules.disko

      inputs.nixos-facter-modules.nixosModules.facter
      {config.facter.reportPath = ./facter.json;}

      flake.nixosModules.desktop-role
    ];

  nix = {
    settings = {
      auto-optimise-store = mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = mkDefault true;
      warn-dirty = mkDefault false;
      trusted-users = [ "conor" ];
    };

    package = pkgs.nixVersions.stable;
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  };

environment.systemPackages = with pkgs; [ efibootmgr efitools efivar fwupd ];
boot = {
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
        enable = true;
        configurationLimit = 20;
        editor = false;
    };
};

users.users.conor = {
    uid = 1000;
    description = "ConorHK";
    isNormalUser = true;
    initialPassword = "pass";
    shell = pkgs.zsh;
    extraGroups = [
        "wheel"
        "tty"
        "sound"
        "networkmanager"
        "libvirtd"
        "input"
        "docker"
        "audio"
    ];
};

programs.zsh.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
      allowUnfreePredicate = _: true;
    };
  };


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

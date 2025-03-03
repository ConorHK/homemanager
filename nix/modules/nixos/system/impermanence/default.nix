{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.impermanence;
in
{

  imports = with inputs; [
    impermanence.nixosModules.impermanence
  ];

  options.system.impermanence = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable system impermanence";
    };
    removeTmpFilesOlderThan = mkOption {
      default = 14;
      type = with types; int;
      description = "amount of days to keep old btrfs files";
    };
  };

  config = mkIf cfg.enable {
    security.sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';

    programs.fuse.userAllowOther = true;

    # This script does the actual wipe of the system
    # So if it doesn't run, the btrfs system effectively acts like a normal system
    # Taken from https://github.com/NotAShelf/nyx/blob/2a8273ed3f11a4b4ca027a68405d9eb35eba567b/modules/core/common/system/impermanence/default.nix
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      # make sure it's done after encryption
      # i.e. LUKS/TPM process
      after = [ "systemd-cryptsetup@cryptroot.service" ];
      # mount the root fs before clearing
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvolid=5 -t btrfs /dev/mapper/cryptroot /mnt
        btrfs subvolume list -o /mnt/root
        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root
      '';
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/secureboot"
        "/var/lib/flatpak"
        "/var/lib/libvirt"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/pipewire"
        "/var/cache/tailscale"
        "/var/db/sudo/"
        "/var/lib/tailscale"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    ];
  };
}

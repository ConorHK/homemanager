{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.impermanence;
in {

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
     boot.initrd.postDeviceCommands = mkIf cfg.enable (lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/pool/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${builtins.toString cfg.removeTmpFilesOlderThan}); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '');

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

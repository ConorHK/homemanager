{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.system.boot;
in
with lib;
{
  imports = with inputs; [
    lanzaboote.nixosModules.lanzaboote
  ];

  options.system.boot = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable booting";
    };
    plymouth = mkOption {
      default = false;
      type = with types; bool;
      description = "enable plymouth boot splash";
    };
    secureBoot = mkOption {
      default = false;
      type = with types; bool;
      description = "enable secureboot";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        efibootmgr
        efitools
        efivar
        fwupd
      ]
      ++ lib.optionals cfg.secureBoot [ sbctl ];

    boot = {
      kernelParams = lib.optionals cfg.plymouth [
        "quiet"
        "splash"
        "loglevel=3"
        "udev.log_level=0"
      ];
      # initrd.verbose = lib.optionals cfg.plymouth false;
      # consoleLogLevel = lib.optionals cfg.plymouth 0;
      initrd.systemd.enable = true;

      lanzaboote = mkIf cfg.secureBoot {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };

      loader = {
        efi = {
          canTouchEfiVariables = true;
        };

        systemd-boot = {
          enable = !cfg.secureBoot;
          configurationLimit = 20;
          editor = false;
        };
      };

      plymouth = {
        enable = cfg.plymouth;
      };
    };
  };
}

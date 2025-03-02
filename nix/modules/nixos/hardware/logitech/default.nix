{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.hardware.logitechMouse;
in
{
  options.hardware.logitechMouse = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable logitech mouse configuration";
    };
  };

  config = mkIf cfg.enable {
    hardware = {
      logitech.wireless.enable = true;
      logitech.wireless.enableGraphical = true; # Solaar.
    };

    environment.systemPackages = with pkgs; [
      solaar
    ];

    services.udev.packages = with pkgs; [
      logitech-udev-rules
      solaar
    ];
  };
}

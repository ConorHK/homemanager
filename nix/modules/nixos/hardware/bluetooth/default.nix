{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.hardware.bluetoothctl;
in
{
  options.hardware.bluetoothctl = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable bluetooth service and packages";
    };
  };

  config = mkIf cfg.enable {
    services.blueman.enable = true;
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
  };
}

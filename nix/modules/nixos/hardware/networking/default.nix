{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable networking";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
    };
    networking.networkmanager.enable = true;
    systemd.network.wait-online.enable = false;
  };
}

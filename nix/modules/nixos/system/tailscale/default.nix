{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.tailscale;
in {
  options.system.tailscale = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable tailscale";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    environment.systemPackages = with pkgs; [ tailscale ];
  };
}



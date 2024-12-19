{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.networking-tools;
in
  with lib;
{
  options = {
    host.home.applications.networking-tools = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Collection of networking tools";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        netcat
        sshuttle
        dig
        net-snmp
      ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.networking-tools;
in
{
  options.cli.programs.networking-tools = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable collection of networking tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      netcat
      sshuttle
      dig
      net-snmp
    ];
  };
}

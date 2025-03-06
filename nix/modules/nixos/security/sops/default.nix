{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.security.sops;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  options.security.sops = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable sops for secret handling";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];
    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}

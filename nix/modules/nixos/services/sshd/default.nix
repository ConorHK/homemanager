{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.sshd;
in
{
  options.cli.programs.ssh = with types; {
    enable = lib.mkOption {
      description = "enable sshd";
      default = false;
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = false;
        PermitRootLogin = false;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        allowSftp = false;
        extraConfig = ''
          AllowTcpForwarding yes
          X11Forwarding no
          AllowAgentForwarding no
          AllowStreamLocalForwarding no
          AuthenticationMethods publickey
        '';

      };
    };
  };
}

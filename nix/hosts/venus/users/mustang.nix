{ flake, ... }:
{
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
  ];

  config = {
    home = {
      sessionVariables = {
        BROWSER = "echo";
      };
      stateVersion = "25.05";
    };

    cli.multiplexers.zellij.enableAutoStart = false;
    cli.programs.ssh = {
      extraHosts.fuji = {
        hostname = "fuji";
        user = "conor";
        port = 22;
        forwardAgent = true;
      };
      extraHosts.dns = {
        hostname = "dns";
        user = "conor";
        port = 22;
        forwardAgent = true;
      };
    };
  };
}

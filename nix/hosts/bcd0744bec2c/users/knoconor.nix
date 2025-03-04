{
  flake,
  config,
  lib,
  ...
}:
with lib;
{
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
  ];

  config = {
    cli.programs.git = {
      defaultBranch = "mainline";
      email = "knoconor@amazon.com";
    };
    home = {
      stateVersion = "25.05";
    };
    cli.programs.ssh.enable = mkForce false;
  };
}

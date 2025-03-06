{
  flake,
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
    cli.multiplexers.zellij.enableAutoStart = false;
    home = {
      stateVersion = "25.05";
    };
    cli.programs.ssh.enable = mkForce false;
    # nix.settings.use-xdg-base-directories = false;
    system.xdg.enableUserDirectories = false;
  };
}

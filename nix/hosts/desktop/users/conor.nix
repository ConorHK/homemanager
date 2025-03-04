{ flake, ... }:
{
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
    flake.homeModules.desktop-role
    flake.homeModules.gaming-role
  ];

  config = {
    home = {
      sessionVariables = {
        BROWSER = "firefox";
      };
      stateVersion = "25.05";
    };
    cli.programs.ssh.extraHosts.server = {
      hostname = "goosebox.org";
      user = "mustang";
      port = 22;
    };
  };
  config.cli.programs.git = {
    defaultBranch = "main";
    email = "dev@conorknowles.com";
  };

}

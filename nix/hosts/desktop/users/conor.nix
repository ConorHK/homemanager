{flake, ...}: {
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
  ];

  config = {
    home = {
      sessionVariables = {
        BROWSER = "firefox";
      };
      stateVersion = "24.11";
    };
    cli.programs.ssh.extraHosts.server = {
      hostname = "goosebox.org";
      user = "mustang";
      port = 22;
    };
  };
}

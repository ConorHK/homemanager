{flake, ...}: {
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
    flake.homeModules.work-role
  ];

  home = {
    sessionVariables = {
      HOSTROLE = "dev";
      BROWSER = "echo"; # print URLs
    };
    stateVersion = "24.11";
  };
}

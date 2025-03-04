{ flake, ... }:
{
  imports = [
    flake.homeModules.common-role
  ];

  config = {
    home = {
      sessionVariables = {
        BROWSER = "echo";
      };
      stateVersion = "25.05";
    };
  };
}

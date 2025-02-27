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
      stateVersion = "24.11";
    };
  };
}

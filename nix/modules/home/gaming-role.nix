{
  flake,
  pkgs,
  ...
}:
{
  desktop.programs.discord.enable = true;
  imports = [
    flake.homeModules.desktop
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      cpu_load_change = true;
    };
  };

  home.packages = with pkgs; [
    lutris
    bottles
  ];
}

{
  flake,
  ...
}:
{
  desktop.programs.discord.enable = true;
  imports = [
    flake.homeModules.desktop
  ];
}

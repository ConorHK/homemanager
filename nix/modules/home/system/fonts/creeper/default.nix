{
  config,
  perSystem,
  lib,
  ...
}:
let
  cfg = config.system.fonts.creeper;
in
with lib;
{
  options.system.fonts.creeper = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable creeper mono bitmap font";
    };
  };

  config = mkIf cfg.enable {
    system.fonts = {
      monospace = "creeper";
      # monospaceNerd = "Cozette";
      monospaceFallback = "Unifont";
    };

    home.packages = [
      perSystem.self.creeper
      # cozette
      # unifont
    ];
  };
}

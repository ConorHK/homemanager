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
    home.packages = [
      perSystem.self.creeper
    ];
  };
}

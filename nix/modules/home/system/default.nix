{ lib, ... }:
with lib;
{
  imports = [
    ./fonts
  ];
  options.system.fonts = {
    monospace = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "default monospace font";
    };
    monospaceNerd = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "default monospace font for icons";
    };
    monospaceFallback = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "default monospace fallback font";
    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.user;
in
{
  options.user = with types; {
    name = mkOption {
      default = "conor";
      type = str;
      description = "the name of the user's account";
    };
    initialPassword = mkOption {
      default = "pass";
      type = str;
      description = "initial password of user";
    };
    extraGroups = mkOption {
      default = [ ];
      type = listOf str;
      description = "groups for the user to be assigned to";
    };
    extraOptions = mkOption {
      default = { };
      type = attrs;
      description = "extra options passed to users.users.<name>";
    };
  };

  config = {
    users.mutableUsers = false;
    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name initialPassword;
      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "audio"
        "sound"
        "video"
        "networkmanager"
        "input"
        "tty"
        "podman"
        "kvm"
        "libvirtd"
      ] ++ cfg.extraGroups;
    } // cfg.extraOptions;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    programs.zsh.enable = true;
  };
}

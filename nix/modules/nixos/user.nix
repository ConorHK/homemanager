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
    # P.S: This option requires you to define a password file for your users
    # inside your configuration.nix - you can generate this password with
    # mkpasswd -m sha-512 > /persist/passwords/notashelf after you confirm /persist/passwords exists
    users.mutableUsers = false;
    users.users.root.hashedPassword = "*"; # lock root account
    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name initialPassword;
      home = "/home/${cfg.name}";
      group = "users";
      # hashedPasswordFile = "/persist/passwords/${cfg.name}";

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

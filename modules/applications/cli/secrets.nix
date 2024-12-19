{config, inputs, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.secrets;
in
  with lib;
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    host.home.applications.secrets = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Secret management using SOPS";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      activation.reload_secrets = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        if [ -e /run/current-system/sw/bin/systemctl ] ; then
            _systemctl="/run/current-system/sw/bin/systemctl"
        elif [ -e /usr/bin/systemctl ] ; then
            _systemctl="/usr/bin/systemctl"
        fi

        if $_systemctl --user list-unit-files sops-nix.service &>/dev/null ; then
            $_systemctl start --user sops-nix
        fi
      '';

      packages = with pkgs;
        [
          age
          gnupg
          pinentry.out
          ssh-to-age
          ssh-to-pgp
          sops
        ];
      
    };


    sops = {
      defaultSopsFile = ../../../secrets/common.yaml;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      secrets = {
        github_token.path = "${config.sops.defaultSymlinkPath}/github_token}";
        ntfy_topic.path = "${config.sops.defaultSymlinkPath}/ntfy_topic}";
      };
    };

    programs.zsh.initExtra = ''
      if [[ -o interactive ]]; then
        export GITHUB_SECRET=$(cat ${config.sops.secrets.github_token.path})
        export NTFY_TOPIC=$(cat ${config.sops.secrets.ntfy_topic.path})
      fi
    '';
  };
}

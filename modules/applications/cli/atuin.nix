{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.atuin;
in
  with lib;
{
  options = {
    host.home.applications.atuin = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Shell history as a DB";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "";
        dialect = "uk";
        update_check = "false";
        filter_mode_shell_up_key_binding = "workspace";
        keymap_mode = "vim-normal";
        common_subcommands = [
            "apt"
            "cargo"
            "composer"
            "dnf"
            "docker"
            "git"
            "go"
            "ip"
            "kubectl"
            "nix"
            "nmcli"
            "npm"
            "pecl"
            "pnpm"
            "podman"
            "port"
            "systemctl"
            "tmux"
            "yarn"
            "brazil"
          ];
      };
    };
  };
}

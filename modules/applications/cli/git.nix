{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.git;
in
  with lib;
{
  options = {
    host.home.applications.git = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Revision control tool";
      };
      defaultBranch = mkOption {
        default = "main";
        type = with types; str;
        description = "Default git branch";
      };
      email = mkOption {
        default = "";
        type = with types; str;
        description = "Default git email";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = "Conor Knowles";
        userEmail = cfg.email;
        extraConfig = {
          init = { defaultBranch = cfg.defaultBranch; };
          pull = { rebase = true; };
        };
        lfs.enable = true;
        difftastic = {
          enable = true;
          background = "dark";
          };
      };

      zsh.shellAliases = {
        gs = "git status";
        gc = "git commit";
        ga = "git add";
        gaa = "git add --all";
        gp = "git push";
        gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        gd = "git diff";
      };
    };
  };
}

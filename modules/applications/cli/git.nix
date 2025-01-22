{
  config,
  lib,
  pkgs,
  ...
}:

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
    home.packages = with pkgs; [
      mergiraf
    ];
    programs = {
      git = {
        enable = true;
        userName = "Conor Knowles";
        userEmail = cfg.email;
        extraConfig = {
          init = {
            defaultBranch = cfg.defaultBranch;
          };
          pull = {
            rebase = true;
          };
          merge.mergiraf = {
            name = "mergiraf";
            driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";
          };
        };
        attributes = [
          "*.java merge=mergiraf"
          "*.rs merge=mergiraf"
          "*.go merge=mergiraf"
          "*.js merge=mergiraf"
          "*.jsx merge=mergiraf"
          "*.json merge=mergiraf"
          "*.yml merge=mergiraf"
          "*.yaml merge=mergiraf"
          "*.toml merge=mergiraf"
          "*.html merge=mergiraf"
          "*.htm merge=mergiraf"
          "*.xhtml merge=mergiraf"
          "*.xml merge=mergiraf"
          "*.c merge=mergiraf"
          "*.cc merge=mergiraf"
          "*.h merge=mergiraf"
          "*.cpp merge=mergiraf"
          "*.hpp merge=mergiraf"
          "*.cs merge=mergiraf"
          "*.dart merge=mergiraf"
          "*.scala merge=mergiraf"
          "*.sbt merge=mergiraf"
          "*.ts merge=mergiraf"
          "*.py merge=mergiraf"
        ];
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

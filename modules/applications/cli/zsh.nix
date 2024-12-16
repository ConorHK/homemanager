{ config, lib,  pkgs, ... }:
let
  cfg = config.host.home.applications.zsh;
in
  with lib;
{
  options = {
    host.home.applications.zsh = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Zsh shell";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      initExtra = ''
        ico_ahead="▲ "
        ico_behind="▼ "
        ico_diverged="↕ "
        color_root="%F{red}"
        color_user="%F{3}"
        color_normal="%F{white}"
        color_git="%F{13}"

  # allow functions in the prompt
        setopt PROMPT_SUBST
        autoload -Uz colors && colors

  # colors for permissions
        if [[ "$EUID" -ne "0" ]]
          then
            color_prompt="''${color_user}"
        else
          color_prompt="''${color_root}"
            fi

            git_prompt() {
              repo=$(git rev-parse --is-inside-work-tree 2> /dev/null)
                if [[ ! "$repo" || "$repo" = false ]]; then
                  return
                    fi

                    bare_repo=$(git rev-parse --is-bare-repository 2> /dev/null)
                    if [ "$bare_repo" = true ]; then
                      return
                        fi

                        branch="$(git branch | grep "^*" | tr -d "*" | tr -d " ")"
                        if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
                          color_git="%F{red}"
                            fi

                            stat=$(git status | sed -n 2p)
              case "$stat" in
                            *ahead*)
                              stat="$ico_ahead"
                              ;;
                            *behind*)
                              stat="$ico_behind"
                              ;;
                            *diverged*)
                              stat="$ico_diverged"
                              ;;
                            *)
                              stat=""
                              ;;
                            esac
                              echo "on %B"''${color_git}''${branch} ''${stat} "%b"
            }

      ssh_prompt() {
        [ "$SSH_CLIENT" ] && echo "''${color_prompt}[$(hostname -s)] "
      }

      PROMPT='%B$(ssh_prompt)%F{15}%(5~|%-1|%3~|%4~) %b$(git_prompt) ''${color_prompt}──── ─''${color_normal} '
        '';

      shellAliases = {
        nix = "noglob nix";
        source-zsh = "source $ZDOTDIR/.zshrc";
        home-manage = "home-manager switch --flake ~/.dotfiles && source $ZDOTDIR/.zshrc";
      };

      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        size = 10000;
        share = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };
  };
}
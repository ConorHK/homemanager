{
  pkgs,
  lib,
  config,
  perSystem,
  ...
}:
with lib;
let
  cfg = config.cli.multiplexers.zellij;

  # depends on fzf
  sesh = pkgs.writeScriptBin "sesh" ''
    #! /usr/bin/env sh

    ZJ_SESSIONS=$(zellij list-sessions -s)
    NO_SESSIONS=$(echo "$ZJ_SESSIONS" | wc -l)

    if [ -z "$ZELLIJ" ]; then
      if [ "$NO_SESSIONS" -ge 2 ]; then
        zellij attach \
        "$(echo "$ZJ_SESSIONS" | ${pkgs.fzf}/bin/fzf)"
      else
         zellij attach -c
      fi
    fi
  '';
in
{
  options.cli.multiplexers.zellij = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable zellij multiplexer";
    };
    enableAutoStart = mkOption {
      default = true;
      type = with types; bool;
      description = "enable zellij to start in any ZSH shell";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.fzf
      sesh
    ];

    programs.zsh.initExtra = mkIf cfg.enableAutoStart (mkOrder 200 ''
      ${sesh}/bin/sesh
    '');

    programs.zellij = {
      enable = true;
    };
    xdg.configFile."zellij/config.kdl".text = ''
      default_shell "zsh"
      default_layout "compact"

      pane_viewport_serialization true
      scrollback_lines_to_serialize 5000

      ui {
        pane_frames {
          rounded_corners true;
        }
      }

      plugins {
        autolock location="file://${perSystem.self.zellij-autolock}" {
          triggers "nvim|vim|cnvim"
          watch_triggers "fzf|zoxide|atuin"
          watch_interval "1.0"
        }
      }
      load_plugins {
        autolock
      }

      keybinds clear-defaults=true {
        locked {
          bind "Ctrl t" { SwitchToMode "Tmux"; }
          bind "Ctrl q" { SwitchToMode "Locked"; }
        }

        normal {
          bind "Enter" {
            WriteChars "\u{000D}";
            MessagePlugin "autolock" {};
          }

          bind "Ctrl t" { SwitchToMode "Tmux"; }
          bind "Ctrl Left" "Ctrl h" { MoveFocus "Left"; }
          bind "Ctrl Right" "Ctrl l" { MoveFocus "Right"; }
          bind "Ctrl Up" "Ctrl k" { MoveFocus "Up"; }
          bind "Ctrl Down" "Ctrl j" { MoveFocus "Down"; }

          unbind "Ctrl b"
        }
        tmux {
          bind "Ctrl t" { Write 2; SwitchToMode "Normal"; }
          bind "Esc" { SwitchToMode "Normal"; }

          bind "g" { SwitchToMode "Locked"; }
          bind "p" { SwitchToMode "Pane"; }
          bind "t" { SwitchToMode "Tab"; }
          bind "n" { SwitchToMode "Resize"; }
          bind "h" { SwitchToMode "Move"; }
          bind "s" { SwitchToMode "Session"; }
          bind "o" { SwitchToMode "Scroll"; }
          bind "?" { SwitchToMode "EnterSearch"; SearchInput 0; }

          bind "q" { Quit; }
        }
        pane {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }

          bind "Ctrl Left" "Ctrl h" { MoveFocus "Left"; }
          bind "Ctrl Right" "Ctrl l" { MoveFocus "Right"; }
          bind "Ctrl Up" "Ctrl k" { MoveFocus "Up"; }
          bind "Ctrl Down" "Ctrl j" { MoveFocus "Down"; }

          bind "v" { NewPane "Right"; SwitchToMode "Normal"; }
          bind "h" { NewPane "Down"; SwitchToMode "Normal"; }
          bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
          bind "x" { CloseFocus; SwitchToMode "Normal"; }
        }
        tab {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }

          bind "c" { NewTab; SwitchToMode "Normal"; }
          bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
          bind "n" { GoToNextTab; }
          bind "p" { GoToPreviousTab; }
        }
        renametab {
          bind "Ctrl c" "Enter" { SwitchToMode "Normal"; }
          bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
        }
        renamepane {
          bind "Ctrl c" "Enter" { SwitchToMode "Normal"; }
          bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
        }
        resize {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }
        }
        move {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }
        }
        scroll {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }
        }
        session {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }

          bind "d" { Detach; }
          bind "s" {
              LaunchOrFocusPlugin "session-manager" {
                  floating true
                  move_to_focused_tab true
              };
              SwitchToMode "Normal"
          }
        }
        entersearch {
          bind "Ctrl c" "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Search"; }
        }
        search {
          bind "Esc" { SwitchToMode "Normal"; }
          bind "Enter" { SwitchToMode "Normal"; }

          bind "j" "Down" { ScrollDown; }
          bind "k" "Up" { ScrollUp; }
          bind "Ctrl d" { PageScrollDown; }
          bind "Ctrl u" { PageScrollUp; }
          bind "n" { Search "down"; }
          bind "b" { Search "up"; }
        }
      }
    '';
  };
}

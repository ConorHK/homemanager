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

  sesh = pkgs.writeScriptBin "sesh" ''
    #! /usr/bin/env sh

    # Taken from https://github.com/zellij-org/zellij/issues/884#issuecomment-1851136980
    # select a directory using zoxide
    ZOXIDE_RESULT=$(zoxide query --interactive)
    # checks whether a directory has been selected
    if [[ -z "$ZOXIDE_RESULT" ]]; then
    	# if there was no directory, select returns without executing
    	exit 0
    fi
    # extracts the directory name from the absolute path
    SESSION_TITLE=$(echo "$ZOXIDE_RESULT" | sed 's#.*/##')

    # get the list of sessions
    SESSION_LIST=$(zellij list-sessions -n | awk '{print $1}')

    # checks if SESSION_TITLE is in the session list
    if echo "$SESSION_LIST" | grep -q "^$SESSION_TITLE$"; then
    	# if so, attach to existing session
    	zellij attach "$SESSION_TITLE"
    else
    	# if not, create a new session
    	echo "Creating new session $SESSION_TITLE and CD $ZOXIDE_RESULT"
    	cd $ZOXIDE_RESULT
    	zellij attach -c "$SESSION_TITLE"
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
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.tmate
      sesh
    ];

    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
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
          bind "Ctrl Left" { MoveFocus "Left"; }
          bind "Ctrl Right" { MoveFocus "Right"; }
          bind "Ctrl Up" { MoveFocus "Up"; }
          bind "Ctrl Down" { MoveFocus "Down"; }

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

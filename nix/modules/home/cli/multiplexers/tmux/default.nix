{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.multiplexers.tmux;
in
{
  options.cli.multiplexers.tmux = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable tmux multiplexer";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;
        aggressiveResize = true;
        escapeTime = 50;
        baseIndex = 1;
        clock24 = true;
        keyMode = "vi";
        focusEvents = true;
        mouse = true;
        newSession = true;
        prefix = "C-t";
        sensibleOnTop = true;
        historyLimit = 50000;
        secureSocket = false;
        plugins = with pkgs; [
          tmuxPlugins.tmux-fzf
          tmuxPlugins.extrakto
          tmuxPlugins.yank
        ];
        extraConfig = ''
          set -g focus-events on
          set -g status-style bg=default
          set -g status-left-length 90
          set -g status-right-length 90
          set -g status-justify left
          set -g status-fg colour7
          set -g status-bg colour235
          set -g status-interval 5
          set -g status-position top
          setw -g window-status-separator " "
          setw -g window-status-format "#I #W ▓░"
          setw -g window-status-current-format " #I #W ▓░"
          set-option -g status-right "░▓ %Y/%m/%d-%u %H%M ▓"
          set-option -g status-left " #S "

          set -g set-clipboard on
          set -g @extrakto_clip_tool_run "tmux_osc52"
          set -ag terminal-overrides ",tmux-256color:Ms=\\E]52;c;%p2%s\\7,xterm*:XT:Ms=\\E]52;c;%p2%s\\7"

          is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
          bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
          bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
          bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
          bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

          bind-key -n 'C-Left' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
          bind-key -n 'C-Down' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
          bind-key -n 'C-Up' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
          bind-key -n 'C-Right' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

          tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
          if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
          if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

          bind-key -T copy-mode-vi 'C-h' select-pane -L
          bind-key -T copy-mode-vi 'C-j' select-pane -D
          bind-key -T copy-mode-vi 'C-k' select-pane -U
          bind-key -T copy-mode-vi 'C-l' select-pane -R

          bind-key -T copy-mode-vi 'C-Left' select-pane -L
          bind-key -T copy-mode-vi 'C-Down' select-pane -D
          bind-key -T copy-mode-vi 'C-Up' select-pane -U
          bind-key -T copy-mode-vi 'C-Right' select-pane -R

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          bind v split-window -h -c "#{pane_current_path}"
          bind h split-window -v -c "#{pane_current_path}"
        '';
      };
    };
  };
}

# Ported from the Mac: the same config, and the fzf session picker on ctrl-f.
{ pkgs, ... }:
let

  # Pick a directory under ~/Documents, land in a session named after it.
  open-session = pkgs.writeShellScriptBin "tmux-open-session" ''
    REPOS_DIRECTORY="$HOME/Documents"

    if ! ${pkgs.tmux}/bin/tmux has-session -t default 2>/dev/null; then
      ${pkgs.tmux}/bin/tmux new-session -d -s default
      exec ${pkgs.tmux}/bin/tmux attach -t default
    fi

    if [ $# -eq 1 ]; then
      selected=$1
    else
      selected=$(find "$REPOS_DIRECTORY" -maxdepth 3 -mindepth 0 -type d | ${pkgs.fzf}/bin/fzf)
    fi
    [ -n "$selected" ] || exit 0

    dirname=$(basename "$selected")
    if ! ${pkgs.tmux}/bin/tmux has-session -t "$dirname" 2>/dev/null; then
      ${pkgs.tmux}/bin/tmux new-session -c "$selected" -d -s "$dirname"
    fi
    if [ -n "$TMUX" ]; then
      ${pkgs.tmux}/bin/tmux switch-client -t "$dirname"
    else
      exec ${pkgs.tmux}/bin/tmux attach -t "$dirname"
    fi
  '';

in
{
  home = {
    packages = [ open-session ];
  };

  programs = {
    tmux = {
      enable = true;
      prefix = "M-a";
      baseIndex = 1;
      escapeTime = 2;
      keyMode = "vi";
      mouse = false;
      shell = "${pkgs.fish}/bin/fish";
      terminal = "screen-256color";
      extraConfig = ''
        # splitting panes with | and -
        bind | split-window -h
        bind - split-window -v

        # moving between panes with prefix h,j,k,l
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # quick window selection
        bind -r C-h select-window -t :-
        bind -r C-l select-window -t :+

        # pane resizing with prefix H,J,K,L
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # synchronize-panes toggle
        bind-key C-s set-window-option synchronize-panes

        # hide the status bar
        bind-key C-a set-option -g status
        set -g status-bg colour240
        set -g status-fg white

        set-option -g status-left-length 50
        set -g terminal-overrides "xterm*:XT:smcup@:rmcup@"
        setw -g allow-rename off
      '';
    };

    fish = {
      interactiveShellInit = ''
        bind \cf 'tmux-open-session; commandline -f repaint'
      '';
    };
  };
}

# Ported from the Mac: the same config, and the fzf session picker on ctrl-f.
{ pkgs, ... }:
let

  sync-worktrees = pkgs.writeShellScriptBin "tmux-sync-worktrees" ''
    session=''${1:-$(${pkgs.tmux}/bin/tmux display-message -p '#S')}
    root=''${2:-$(${pkgs.tmux}/bin/tmux display-message -p '#{session_path}')}
    ${pkgs.git}/bin/git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
    ${pkgs.git}/bin/git -C "$root" worktree list --porcelain | sed -n 's/^worktree //p' | while read -r wt; do
      wtname=$(basename "$wt")
      [ "$wtname" = "$session" ] && continue
      wtname=''${wtname#"$session-"}
      if ! ${pkgs.tmux}/bin/tmux list-windows -t "$session" -F '#{window_name}' | grep -qx "$wtname"; then
        ${pkgs.tmux}/bin/tmux new-window -d -t "$session" -n "$wtname" -c "$wt"
      fi
    done
  '';

  new-worktree = pkgs.writeShellScriptBin "wt" ''
    branch=$1
    if [ -z "$branch" ]; then echo "uso: wt <branch>"; exit 1; fi
    common=$(${pkgs.git}/bin/git rev-parse --path-format=absolute --git-common-dir) || exit 1
    root=$(dirname "$common")
    name=$(basename "$root")
    path=$(dirname "$root")/$name-$branch
    ${pkgs.git}/bin/git -C "$root" fetch origin 2>/dev/null || true
    existing=$(${pkgs.git}/bin/git -C "$root" worktree list --porcelain \
      | ${pkgs.gawk}/bin/awk -v b="branch refs/heads/$branch" '/^worktree /{p=substr($0,10)} $0==b{print p; exit}')
    if [ -n "$existing" ]; then
      path=$existing
    elif ${pkgs.git}/bin/git -C "$root" show-ref --verify --quiet "refs/heads/$branch" \
      || ${pkgs.git}/bin/git -C "$root" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      ${pkgs.git}/bin/git -C "$root" worktree add "$path" "$branch" || exit 1
    else
      base=$(${pkgs.git}/bin/git -C "$root" symbolic-ref -q refs/remotes/origin/HEAD || echo HEAD)
      ${pkgs.git}/bin/git -C "$root" worktree add "$path" -b "$branch" "$base" || exit 1
    fi
    if ${pkgs.tmux}/bin/tmux has-session -t "$name" 2>/dev/null; then
      ${sync-worktrees}/bin/tmux-sync-worktrees "$name" "$root"
      wtname=$(basename "$path")
      wtname=''${wtname#"$name-"}
      ${pkgs.tmux}/bin/tmux select-window -t "$name:$wtname" 2>/dev/null || true
      if [ -n "$TMUX" ]; then
        ${pkgs.tmux}/bin/tmux switch-client -t "$name" 2>/dev/null || true
      fi
    fi
  '';

  worktree-popup = pkgs.writeShellScriptBin "wt-popup" ''
    common=$(${pkgs.git}/bin/git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0
    root=$(dirname "$common")
    ${pkgs.git}/bin/git -C "$root" fetch origin 2>/dev/null || true
    out=$(${pkgs.git}/bin/git -C "$root" for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin \
      | sed 's|^origin/||' | grep -vx HEAD | sort -u \
      | ${pkgs.fzf}/bin/fzf --print-query --prompt='worktree> ') || true
    branch=$(printf '%s\n' "$out" | tail -n1)
    [ -n "$branch" ] || exit 0
    ${new-worktree}/bin/wt "$branch" || { echo; read -r -p 'error — enter para cerrar' _; }
  '';

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

    ${sync-worktrees}/bin/tmux-sync-worktrees "$dirname" "$selected"

    if [ -n "$TMUX" ]; then
      ${pkgs.tmux}/bin/tmux switch-client -t "$dirname"
    else
      exec ${pkgs.tmux}/bin/tmux attach -t "$dirname"
    fi
  '';

in
{
  home = {
    packages = [ open-session sync-worktrees new-worktree worktree-popup ];
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
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

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

        bind C-w run-shell ${sync-worktrees}/bin/tmux-sync-worktrees
        bind W display-popup -d "#{pane_current_path}" -E -w 60% -h 50% ${worktree-popup}/bin/wt-popup

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

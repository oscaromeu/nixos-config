# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git
	fzf)

source $ZSH/oh-my-zsh.sh


# TMUX 
alias tmux_open_session="/usr/local/bin/tmux_open_session"

_switch_session(){

    tmux_open_session   "$HOME/Documents/Repos" "$HOME/Documents"

}

zle -N _switch_session
bindkey '^f' _switch_session

# SOPS 
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

# Atuin
eval "$(atuin init zsh)"
eval "$(/Users/oscaromeu/.local/bin/zoxide init zsh)" 

# K8s krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/oscaromeu/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/oscaromeu/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/oscaromeu/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/oscaromeu/google-cloud-sdk/completion.zsh.inc'; fi

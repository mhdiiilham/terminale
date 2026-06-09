export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="apple"

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY

plugins=(git history-substring-search)
source $ZSH/oh-my-zsh.sh

# Autosuggestions — fish-like grey suggestions as you type
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"
bindkey '^[^M' autosuggest-accept        # Alt+Enter: accept suggestion

# Syntax highlighting — commands turn green (valid) or red (invalid)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf — Ctrl+R: fuzzy history  |  Ctrl+T: file picker  |  Alt+C: cd into dir
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# zoxide — smart cd that learns your frequent dirs
eval "$(zoxide init zsh --cmd cd)"

# direnv — auto-load .envrc per project directory
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# Keybindings
bindkey '^[[1;5C' forward-word                  # Ctrl+Right: next word
bindkey '^[[1;5D' backward-word                 # Ctrl+Left:  prev word
bindkey '^H'      backward-kill-word            # Ctrl+Backspace: delete prev word
bindkey '^[[3;5~' kill-word                     # Ctrl+Delete:    delete next word
bindkey '^[[H'    beginning-of-line             # Home
bindkey '^[[F'    end-of-line                   # End
bindkey '^[[3~'   delete-char                   # Delete key
bindkey '^P'      history-substring-search-up   # Ctrl+P: search history up
bindkey '^N'      history-substring-search-down # Ctrl+N: search history down

# Aliases — fallback to standard tools if modern ones aren't installed
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lAF --icons --git'
  alias la='eza -A --icons'
else
  alias ll='ls -lAFh'
  alias la='ls -A'
fi
command -v bat &>/dev/null && alias cat='bat'
command -v lazygit &>/dev/null && alias lg='lazygit'

alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Docker CLI completions
fpath=(/Users/mo/.docker/completions $fpath)
autoload -Uz compinit && compinit

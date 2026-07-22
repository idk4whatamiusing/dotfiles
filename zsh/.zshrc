autoload -Uz compinit && compinit -d "$HOME/.cache/zsh/zcompdump"

HISTFILE="$HOME/.config/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

eval "$(/opt/homebrew/bin/brew shellenv)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--color=fg:#cdcdcd --color=bg:#141415 --color=hl:#f3be7c --color=fg+:#aeaed1 --color=bg+:#252530 --color=hl+:#f3be7c --color=border:#606079 --color=header:#6e94b2 --color=gutter:#141415 --color=spinner:#7fa563 --color=info:#f3be7c --color=pointer:#aeaed1 --color=marker:#d8647e --color=prompt:#bb9dbd"

export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.cargo/env"

PROMPT='%B%F{#c48282}%n%f%b@%B%F{#6e94b2}%m%f%b %B%F{#e8b589}%~%f%b %# '

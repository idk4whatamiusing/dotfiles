autoload -Uz compinit && compinit -d "$HOME/.cache/zsh/zcompdump"

HISTFILE="$HOME/.config/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

eval "$(/opt/homebrew/bin/brew shellenv)"

conda() {
  unfunction conda
  __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
      . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
      export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
  fi
  unset __conda_setup
  conda "$@"
}

fnm() {
  unfunction fnm
  eval "$(fnm env --use-on-cd)"
  fnm "$@"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--color=fg:#cdcdcd --color=bg:#141415 --color=hl:#f3be7c --color=fg+:#aeaed1 --color=bg+:#252530 --color=hl+:#f3be7c --color=border:#606079 --color=header:#6e94b2 --color=gutter:#141415 --color=spinner:#7fa563 --color=info:#f3be7c --color=pointer:#aeaed1 --color=marker:#d8647e --color=prompt:#bb9dbd"

export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.cargo/env"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

PROMPT='%B%F{#c48282}%n%f%b@%B%F{#6e94b2}%m%f%b %B%F{#e8b589}%~%f%b %# '

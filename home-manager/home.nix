{ config, pkgs, ... }:

{
  home.username = "x";
  home.homeDirectory = "/Users/x";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # ---- Zsh ----
  programs.zsh = {
    enable = true;
    dotDir = "/Users/x/.config/zsh";
    completionInit = "autoload -Uz compinit && compinit -d \"$HOME/.cache/zsh/zcompdump\"";
    envExtra = ''
      export PATH="$HOME/.nix-profile/bin:$PATH"
      export EDITOR='vim'
      export PATH="$HOME/.opencode/bin:$PATH"

      # Keep zsh runtime junk out of the dotfiles dir
      export ZCOMPDUMP="$HOME/.cache/zsh/zcompdump"
      export SHELL_SESSION_DIR="$HOME/.cache/zsh/sessions"
    '';
    initContent = ''
      export ZSH="$HOME/.oh-my-zsh"
      ZSH_THEME="robbyrussell"
      plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
      export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
      source $ZSH/oh-my-zsh.sh

      eval "$(/opt/homebrew/bin/brew shellenv)"

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

      eval "$(fnm env --use-on-cd)"

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
      export FZF_DEFAULT_OPTS="--color=fg:#cdcdcd --color=bg:#141415 --color=hl:#f3be7c --color=fg+:#aeaed1 --color=bg+:#252530 --color=hl+:#f3be7c --color=border:#606079 --color=header:#6e94b2 --color=gutter:#141415 --color=spinner:#7fa563 --color=info:#f3be7c --color=pointer:#aeaed1 --color=marker:#d8647e --color=prompt:#bb9dbd"

      export PATH="$HOME/.local/bin:$PATH"

      HISTSIZE=50000
      SAVEHIST=50000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE

      # Vague prompt colors
      PROMPT='%{%F{#c48282}%}%n%{%f%}@%{%F{#6e94b2}%}%m%{%f%} %{%F{#e8b589}%}%~%{%f%} %{%F{#7fa563}%}$(git_prompt_info)%{%f%} %# '

      # Ensure Nix-managed binaries take precedence over Homebrew
      export PATH="$HOME/.nix-profile/bin:$PATH"
    '';
  };

  # ---- Packages ----
  home.packages = with pkgs; [
    vim
    tmux
    ripgrep
    fzf
    htop
    wget
    git
    rust-analyzer
    gleam
    fnm
    opencode
    gh
  ];

  # ---- Git ----
  programs.git = {
    enable = true;
    settings = {
      user.name = "khair";
      user.email = "kyahifarakpdtahein@gmail.com";
      init.defaultBranch = "main";
      alias.co = "checkout";
      alias.br = "branch";
      alias.ci = "commit";
      alias.st = "status";
    };
  };

  # ---- aerospace window manager config ----
  home.file.".config/aerospace/aerospace.toml".source = ./dotfiles/aerospace/aerospace.toml;
}

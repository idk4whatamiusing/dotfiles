{ config, pkgs, ... }:

{
  home.username = "x";
  home.homeDirectory = "/Users/x";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

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
    nodejs
    opencode
    gh
  ];

  # ---- aerospace window manager config ----
  home.file.".config/aerospace/aerospace.toml".source = ./dotfiles/aerospace/aerospace.toml;

  # ---- Vim ----
  home.file.".config/vim/vimrc".source = ./dotfiles/vim/vimrc;
  home.file.".config/vim/colors/vague.vim".source = ./dotfiles/vim/colors/vague.vim;

  # ---- Tmux ----
  home.file.".config/tmux/tmux.conf".source = ./dotfiles/tmux/tmux.conf;

  # ---- Zsh ----
  home.file.".config/zsh/.zshenv".source = ./dotfiles/zsh/.zshenv;
  home.file.".config/zsh/.zprofile".source = ./dotfiles/zsh/.zprofile;
  home.file.".config/zsh/.zshrc".source = ./dotfiles/zsh/.zshrc;

  # ---- Git ----
  home.file.".config/git/config".source = ./dotfiles/git/config;

  # ---- Coc ----
  home.file.".config/coc/coc-settings.json".source = ./dotfiles/coc/coc-settings.json;
  home.file.".config/coc/memos.json".source = ./dotfiles/coc/memos.json;
  home.file.".config/coc/extensions/package.json".source = ./dotfiles/coc/extensions/package.json;

  # ---- Nix ----
  home.file.".config/nix/nix.conf".source = ./dotfiles/nix/nix.conf;
}

{ config, pkgs, lib, ... }:

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
    watchman
    cocoapods
    jdk17
    opencode
    openspec
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

  # ---- OpenCode ----
  home.file.".config/opencode/opencode.json".source = ./dotfiles/opencode/opencode.json;

  # ---- One-time installers (GSD + BMAD) ----
  home.activation.installGSD = lib.mkAfter ''
    if ! command -v gsd-help &>/dev/null && [ ! -f "${config.home.homeDirectory}/.config/opencode/commands/gsd-help.md" ]; then
      echo "Installing GSD (Get Shit Done) for OpenCode..."
      npx get-shit-done-cc --opencode --global 2>/dev/null || echo "GSD install skipped — run manually: npx get-shit-done-cc --opencode --global"
    fi
  '';

  home.activation.installBMAD = lib.mkAfter ''
    if [ ! -d "${config.home.homeDirectory}/.agents/skills/bmad-help" ]; then
      echo "Installing BMAD Method for OpenCode..."
      npx bmad-method install --non-interactive 2>/dev/null || echo "BMAD install skipped — run manually: npx bmad-method install"
    fi
  '';
}

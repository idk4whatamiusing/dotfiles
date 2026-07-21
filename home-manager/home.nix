{ config, pkgs, lib, ... }:

{
  home.username = "x";
  home.homeDirectory = "/Users/x";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # ---- Vim ----
  home.file.".config/vim/vimrc".source = ./dotfiles/vim/vimrc;
  home.file.".config/vim/colors/vague.vim".source = ./dotfiles/vim/colors/vague.vim;

  # ---- Tmux ----
  home.file.".config/tmux/tmux.conf".source = ./dotfiles/tmux/tmux.conf;

  # ---- Zsh ----
  # ~/.zshenv must exist and set ZDOTDIR so zsh finds the rest
  home.file.".zshenv" = {
    text = ''export ZDOTDIR="$HOME/.config/zsh"'';
    force = true;
  };
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

  # ---- Homebrew ----
  home.file.".config/homebrew/Brewfile" = {
    source = ./dotfiles/homebrew/Brewfile;
    force = true;
  };

  # ---- Homebrew Bundle ----
  home.activation.brewBundle = lib.mkAfter ''
    echo "Running brew bundle..."
    /opt/homebrew/bin/brew bundle --file="${config.home.homeDirectory}/.config/homebrew/Brewfile" --no-upgrade --quiet || true
  '';

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

  home.activation.ensureOpenspecPlugin = lib.mkAfter ''
    if [ ! -d "${config.home.homeDirectory}/.config/opencode/node_modules/opencode-plugin-openspec" ]; then
      echo "Reinstalling opencode-plugin-openspec..."
      cd "${config.home.homeDirectory}/.config/opencode" && npm install opencode-plugin-openspec 2>/dev/null || true
    fi
  '';
}

#!/usr/bin/env bash
# Bootstrap script — Homebrew + zsh dotfiles setup
# Replaces the old Nix-based bootstrapper
set -euo pipefail

echo "=== 1. Xcode CLI Tools ==="
xcode-select --install 2>/dev/null || echo "already installed"

echo "=== 2. Homebrew ==="
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed"
fi

echo "=== 3. Clone dotfiles ==="
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}"
if [ ! -d "$TARGET/.git" ]; then
  git clone https://github.com/idk4whatamiusing/dotfiles.git "$TARGET"
fi

echo "=== 4. Create ~/.zshenv (ZDOTDIR pointer) ==="
cat > ~/.zshenv << 'EOF'
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshenv"
EOF

echo "=== 5. Symlink configs ==="
DOTFILES="${XDG_CONFIG_HOME:-$HOME/.config}/home-manager/dotfiles"

mkdir -p ~/.config/zsh ~/.config/git ~/.config/tmux ~/.config/vim/colors ~/.config/coc ~/.config/aerospace ~/.config/homebrew ~/.config/opencode

ln -sf "$DOTFILES/zsh/.zshenv"          ~/.config/zsh/.zshenv
ln -sf "$DOTFILES/zsh/.zprofile"        ~/.config/zsh/.zprofile
ln -sf "$DOTFILES/zsh/.zshrc"           ~/.config/zsh/.zshrc
ln -sf "$DOTFILES/git/config"           ~/.config/git/config
ln -sf "$DOTFILES/tmux/tmux.conf"       ~/.config/tmux/tmux.conf
ln -sf "$DOTFILES/vim/vimrc"            ~/.config/vim/vimrc
ln -sf "$DOTFILES/vim/colors/vague.vim" ~/.config/vim/colors/vague.vim
ln -sf "$DOTFILES/coc/coc-settings.json" ~/.config/coc/coc-settings.json
ln -sf "$DOTFILES/aerospace/aerospace.toml" ~/.config/aerospace/aerospace.toml
ln -sf "$DOTFILES/homebrew/Brewfile"    ~/.config/homebrew/Brewfile
cp "$DOTFILES/opencode/opencode.json"   ~/.config/opencode/opencode.jsonc

echo "=== 6. Oh My Zsh ==="
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
else
  echo "Oh My Zsh already installed"
fi

echo "=== 7. Install Homebrew packages ==="
brew bundle --file ~/.config/homebrew/Brewfile --no-upgrade || true

echo "=== 8. fnm & Node ==="
eval "$(fnm env --use-on-cd)"
fnm install 24 2>/dev/null || true

echo "=== 9. macOS defaults ==="
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/scripts/.macos" ]; then
  bash "${XDG_CONFIG_HOME:-$HOME/.config}/scripts/.macos"
fi

echo "=== 10. GitHub CLI auth ==="
gh auth login 2>/dev/null || echo "Run 'gh auth login' manually"

echo "=== 11. OpenCode plugins ==="
cd ~/.config/opencode
npm install opencode-plugin-openspec @dietrichgebert/ponytail 2>/dev/null || true

echo ""
echo "=== Post-install reminders ==="
echo "  - Grant AeroSpace: System Settings -> Privacy -> Accessibility -> AeroSpace"
echo "  - Download Chrome from https://www.google.com/chrome/"
echo "  - Log out/in for macOS Spaces / Dark Mode to fully apply"
echo "  - Reopen Terminal for the new zsh config to take effect"
echo ""
echo "Done! Your Mac is now configured via Homebrew + zsh."

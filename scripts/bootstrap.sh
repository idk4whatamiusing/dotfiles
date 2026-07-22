#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. Xcode CLI Tools ==="
xcode-select --install 2>/dev/null || echo "already installed"

echo "=== 2. Homebrew ==="
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "already installed"
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

echo "=== 5. Oh My Zsh ==="
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
else
  echo "already installed"
fi

echo "=== 6. Install Homebrew packages ==="
brew bundle --file ~/.config/homebrew/Brewfile --no-upgrade || true

echo "=== 7. fnm & Node ==="
eval "$(fnm env --use-on-cd)"
fnm install 24 2>/dev/null || true

echo "=== 8. macOS defaults ==="
if [ -f ~/.config/scripts/.macos ]; then
  bash ~/.config/scripts/.macos
fi

echo "=== 9. GitHub CLI auth ==="
gh auth login 2>/dev/null || echo "Run 'gh auth login' manually"

echo "=== 10. OpenCode plugins ==="
cd ~/.config/opencode
npm install opencode-plugin-openspec 2>/dev/null || true

echo ""
echo "Done! Restart Terminal for the new zsh config to take effect."

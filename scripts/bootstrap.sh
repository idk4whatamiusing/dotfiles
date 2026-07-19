#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. Xcode CLI Tools ==="
xcode-select --install 2>/dev/null || echo "already installed"

echo "=== 2. Nix (official installer) ==="
curl -L https://nixos.org/nix/install | sh
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
mkdir -p ~/.config/nix
echo 'extra-experimental-features = nix-command flakes' > ~/.config/nix/nix.conf

echo "=== 3. Clone dotfiles ==="
cd ~
git clone https://github.com/idk4whatamiusing/dotfiles.git ~/.config

echo "=== 4. Remove temp nix.conf (the flake supplies its own) ==="
rm -f ~/.config/nix/nix.conf

echo "=== 5. Create ~/.zshenv pointer ==="
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

echo "=== 6. Oh My Zsh ==="
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true

echo "=== 7. Homebrew ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>/dev/null || true
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

echo "=== 8. Build & activate nix system ==="
cd ~/.config
nix build .#darwinConfigurations.x.config.system.build.toplevel -o /tmp/darwin-result
sudo /tmp/darwin-result/sw/bin/darwin-rebuild switch --flake ~/.config#x

echo "=== 9. fnm & Node ==="
eval "$(fnm env --use-on-cd)"
fnm install 24

echo "=== 10. GitHub CLI auth ==="
gh auth login

echo ""
echo "=== 11. Post-install reminders ==="
echo "  - Grant AeroSpace: System Settings -> Privacy -> Accessibility -> AeroSpace"
echo "  - Download Chrome from https://www.google.com/chrome/"
echo "  - Log out/in for macOS Spaces / Dark Mode to fully apply"
echo "  - Reopen Terminal for the new zsh config to take effect"
echo ""
echo "Done! Your Mac is now reproducibly configured via Nix."

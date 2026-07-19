# Not tracked by Nix

These settings and apps cannot be managed declaratively by Nix/nix-darwin/home-manager.
They must be set up manually (or are automatically configured on first use).

## macOS protected / TCC-controlled domains
- Reduce motion / transparency (com.apple.universalaccess — write protected on macOS 26+)
- Privacy & Security permissions (Accessibility, Screen Recording, etc.)

## System settings (no defaults key available)
- Desktop wallpaper / screensaver style
- Network / Wi-Fi settings, VPNs
- Printer configuration
- Bluetooth pairings
- Apple Account / iCloud / App Store purchases
- Touch ID / Face ID
- Notification preferences per app
- Finder sidebar favorites
- Login items (user-level)
- Passwords / passkeys

## Apps installed manually (not in nixpkgs or Homebrew)
- **Google Chrome** — download from https://www.google.com/chrome/
- Any other `.dmg`-installed apps (Discord, Figma, etc.)

## One-time GUI grants
- **AeroSpace Accessibility permission** — System Settings → Privacy → Accessibility
- **AeroSpace automation access** — may be prompted on first launch

## Bootstrap steps (not reproducible via rebuild)
- Installing Nix itself (bootstrap script handles this)
- Cloning this dotfiles repo
- Creating `~/.zshenv` pointer
- Installing Oh My Zsh
- Installing Homebrew
- `gh auth login`

See `scripts/bootstrap.sh` for the automated setup script.

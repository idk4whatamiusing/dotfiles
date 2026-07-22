# Not tracked

These settings and apps must be set up manually (or are automatically configured on first use).

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

## Apps installed manually (not in Homebrew)
- **Google Chrome** — download from https://www.google.com/chrome/
- Any other `.dmg`-installed apps (Discord, Figma, etc.)

## Bootstrap steps
- Cloning this dotfiles repo to `~/.config`
- Creating `~/.zshenv` pointer
- Installing Oh My Zsh
- Installing Homebrew
- `gh auth login`

See `scripts/bootstrap.sh` for the automated setup script.

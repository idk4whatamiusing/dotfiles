{ config, pkgs, ... }:

{
  # ---- Host identity ----
  networking.hostName = "x";
  system.primaryUser = "x";
  system.stateVersion = 6;

  # ---- Nix ----
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---- macOS settings (codified from current customizations) ----
  # nix-darwin's system.defaults only models a subset of keys, so we apply the
  # full set (exactly as currently configured) via an activation script.
  system.activationScripts.applyUserDefaults = {
    text = ''
      # ---- Global (NSGlobalDomain) ----
      defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
      defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"
      defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -int 0
      defaults write NSGlobalDomain com.apple.springing.enabled -bool true
      defaults write NSGlobalDomain com.apple.springing.delay -float 0.5
      defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
      defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.875
      defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

      # ---- Dock ----
      defaults write com.apple.dock autohide -bool true
      defaults write com.apple.dock magnification -bool true
      defaults write com.apple.dock largesize -int 45
      defaults write com.apple.dock tilesize -int 31
      defaults write com.apple.dock show-recents -bool false
      defaults write com.apple.dock wvous-bl-corner -int 5
      defaults write com.apple.dock wvous-br-corner -int 14

      # ---- Finder ----
      defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
      defaults write com.apple.finder FXRemoveOldTrashItems -bool true
      defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
      defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

      # ---- Trackpad ----
      for domain in com.apple.driver.AppleBluetoothMultitouch.trackpad com.apple.AppleMultitouchTrackpad; do
        defaults write "$domain" Clicking -bool true
        defaults write "$domain" Dragging -bool true
        defaults write "$domain" TrackpadRightClick -bool true
        defaults write "$domain" FirstClickThreshold -int 2
        defaults write "$domain" SecondClickThreshold -int 2
        defaults write "$domain" ForceSuppressed -bool false
      done

      # Apply UI changes without full logout
      killall Dock 2>/dev/null || true
      killall Finder 2>/dev/null || true
    '';
  };

  # ---- Apps via Homebrew casks ----
  homebrew = {
    enable = true;
    taps = [ "nikitabobko/tap" ];
    casks = [
      "miniconda"
      { name = "aerospace"; trusted = true; }
      "helium-browser"
    ];
    # default onActivation: does NOT uninstall unlisted apps (GarageBand etc. stay)
  };
}

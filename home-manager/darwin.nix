{ config, pkgs, ... }:

{
  # ---- Host identity ----
  networking.hostName = "x";
  system.primaryUser = "x";
  system.stateVersion = 6;

  # ---- Nix ----
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---- macOS settings (declarative via system.defaults) ----

  # Global / Appearance
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    NSTableViewDefaultSizeMode = 1;
    "com.apple.springing.enabled" = true;
    "com.apple.springing.delay" = 0.5;
    "com.apple.trackpad.forceClick" = true;
    "com.apple.trackpad.scaling" = 0.875;

    # Developer typing tweaks (vim-friendly)
    ApplePressAndHoldEnabled = false;       # keys repeat when held
    InitialKeyRepeat = 10;                  # fast repeat start
    KeyRepeat = 1;                          # fast repeat rate
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;

    # Sound — mute alert volume, disable volume change feedback
    "com.apple.sound.beep.volume" = 0.0;
    "com.apple.sound.beep.feedback" = 0;
  };

  # Settings not natively modeled go via CustomUserPreferences
  system.defaults.CustomUserPreferences = {
    "NSGlobalDomain" = {
      AppleActionOnDoubleClick = "Maximize";
      AppleMiniaturizeOnDoubleClick = 0;
    };
    "com.apple.AppleMultitouchTrackpad" = {
      TrackpadFiveFingerPinchGesture = 2;  # Launchpad
    };
  };

  # Dock
  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0;           # instant show
    autohide-time-modifier = 0.0;   # instant animation
    magnification = true;
    largesize = 45;
    tilesize = 31;
    show-recents = false;
    mineffect = "genie";
    orientation = "bottom";
    expose-animation-duration = 0.0;  # faster Mission Control
    wvous-bl-corner = 5;   # Mission Control
    wvous-br-corner = 14;  # Quick Note
  };

  # Finder
  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv";  # List view
    FXRemoveOldTrashItems = true;
    ShowExternalHardDrivesOnDesktop = true;
    ShowRemovableMediaOnDesktop = true;
    ShowHardDrivesOnDesktop = false;
    ShowPathbar = true;
    AppleShowAllExtensions = true;
    FXEnableExtensionChangeWarning = false;
    _FXSortFoldersFirst = true;
    _FXShowPosixPathInTitle = true;
    NewWindowTarget = "Home";
  };

  # Trackpad (built-in; Bluetooth domain not set here)
  system.defaults.trackpad = {
    # Tap + drag
    Clicking = true;           # tap to click
    Dragging = true;
    TrackpadRightClick = true; # two-finger right click
    TrackpadThreeFingerDrag = false;

    # Click firmness
    FirstClickThreshold = 2;   # firm
    SecondClickThreshold = 2;  # firm
    ForceSuppressed = false;   # force click on
    ActuateDetents = true;     # haptic feedback

    # Gestures – vertical swipe
    TrackpadThreeFingerVertSwipeGesture = 2;  # Mission Control
    TrackpadFourFingerVertSwipeGesture = 2;   # Mission Control

    # Gestures – horizontal / pinch
    TrackpadThreeFingerHorizSwipeGesture = 0;
    TrackpadFourFingerHorizSwipeGesture = 2;  # swipe between apps
    TrackpadFourFingerPinchGesture = 2;       # Launchpad / Desktop

    # Other
    TrackpadThreeFingerTapGesture = 0;
    TrackpadTwoFingerDoubleTapGesture = true; # smart zoom
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 3; # Notification Center
    TrackpadMomentumScroll = true;
    TrackpadPinch = true;
    TrackpadRotate = true;
    DragLock = false;
    TrackpadCornerSecondaryClick = 0;
  };

  # Stage Manager (Window Manager)
  system.defaults.WindowManager = {
    GloballyEnabled = true;   # Stage Manager on
    AutoHide = true;
    EnableStandardClickToShowDesktop = false;
    HideDesktop = true;
    EnableTiledWindowMargins = true;
    StandardHideDesktopIcons = false;
    StandardHideWidgets = false;
    StageManagerHideWidgets = false;
    AppWindowGroupingBehavior = true; # All at once

    # Disable macOS native tiling to avoid conflicts with AeroSpace
    EnableTilingByEdgeDrag = false;
    EnableTopTilingByEdgeDrag = false;
    EnableTilingOptionAccelerator = false;
  };

  # Spaces — AeroSpace recommended: disable "Displays have separate Spaces"
  system.defaults.spaces.spans-displays = true;

  # Screenshots — no shadow, PNG format on Desktop
  system.defaults.screencapture = {
    location = "~/Desktop";
    type = "png";
    disable-shadow = true;
  };

  # Security — require password after sleep/screensaver
  system.defaults.screensaver = {
    askForPassword = true;
    askForPasswordDelay = 5;
  };

  # Clock in menu bar
  system.defaults.menuExtraClock = {
    IsAnalog = false;
    Show24Hour = true;
    ShowAMPM = false;
    ShowDate = 0;          # never
    ShowDayOfWeek = true;
    ShowSeconds = false;
  };

  # Control Center — show battery %, sound, and Bluetooth in menu bar
  system.defaults.controlcenter = {
    BatteryShowPercentage = true;
    Sound = true;
    Bluetooth = true;
  };

  # Disable downloaded-app quarantine warning
  system.defaults.LaunchServices.LSQuarantine = false;

  # Control macOS major updates manually (no auto-install)
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

  # Apply UI changes immediately
  system.activationScripts.applyUserDefaults.text = ''
    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true
  '';

  # Force stock Terminal default profile background to black
  system.activationScripts.terminalBlackBg.text = ''
    PLIST=~/Library/Preferences/com.apple.Terminal.plist
    for ch in BackgroundColorR BackgroundColorG BackgroundColorB; do
      /usr/libexec/PlistBuddy -c "Set :WindowSettings:Basic:$ch 0" "$PLIST" 2>/dev/null || true
    done
    defaults write com.apple.Terminal "Default Window Settings" -string "Basic"
    defaults write com.apple.Terminal "Startup Window Settings" -string "Basic"
  '';

  # ---- Apps via Homebrew casks ----
  homebrew = {
    enable = true;
    taps = [ "nikitabobko/tap" ];
    casks = [
      "miniconda"
      { name = "aerospace"; trusted = true; }
    ];
    # default onActivation: does NOT uninstall unlisted apps (GarageBand etc. stay)
  };
}

{ config, pkgs, lib, ... }:

{
  # Darwin (Mac) system-level configuration
  # This is used with nix-darwin for full system management

  imports = [
    # Home Manager is imported in flake.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Basic system utilities
    git
    curl
    wget
  ];

  # Nix configuration
  nix = {
    enable = true;
    package = pkgs.nix;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [ "root" "@admin" ];
    };

    gc = {
      automatic = true;
      interval = { Day = 7; };
      options = "--delete-older-than 7d";
    };
  };

  # Darwin-specific configuration
  system = {
    defaults = {
      # NSGlobalDomain
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSDisableAutomaticTermination = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";
        NSDocumentSaveNewDocumentsToTemporaryLocation = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.feedback" = 0;
      };

      # Dock
      dock = {
        autohide = true;
        show-recents = false;
        tilesize = 64;
        largesize = 64;
        magnification = false;
        orientation = "bottom";
        show-process-indicators = true;
        launchanim = false;
        mru-spaces = false;
        wvous-bl-corner = 0;
        wvous-br-corner = 0;
        wvous-tl-corner = 0;
        wvous-tr-corner = 0;
      };

      # Finder
      finder = {
        AppleShowAllFiles = true;
        ShowExtensionsForKnownFileTypes = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
      };

      # Safari
      Safari = {
        ShowFullURLInSmartSearchField = true;
        IncludeDevelopMenu = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };

      # Screenshots
      screencapture = {
        location = "${config.users.users.viryoke.home}/Library/Application Support/screenshots";
        type = "png";
        disable-shadow = true;
      };

      # Trackpad
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    # Keyboard
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  # Fonts
  fonts.fonts = with pkgs; [
    jetbrains-mono
    fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Programs
  programs = {
    # Git
    git.enable = true;

    # Zsh
    zsh.enable = true;
  };

  # Services
  services = {
    # Nix-daemon is auto-enabled
  };

  # Users
  users.users.viryoke = {
    home = "/Users/viryoke";
    shell = pkgs.zsh;
  };

  # Homebrew integration (optional)
  # homebrew = {
  #   enable = true;
  #   onActivation = {
  #     cleanup = "uninstall";
  #     upgrade = true;
  #   };
  #   taps = [
  #     "homebrew/cask"
  #     "homebrew/cask-fonts"
  #   ];
  #   casks = [
  #     "orbstack"
  #     "rectangle"
  #     "ghostty"
  #     "visual-studio-code"
  #   ];
  # };

  # System state version
  system.stateVersion = 5;
}
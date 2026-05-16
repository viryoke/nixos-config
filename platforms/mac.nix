{ config, pkgs, lib, ... }:

{
  # Mac-specific imports
  imports = [
    # All cross-platform modules are imported from home.nix
    # Add any Mac-specific modules here if needed
  ];

  # Mac-specific packages
  home.packages = with pkgs; [
    # Mac system tools
    # Note: Many of these might be better installed via Homebrew

    # Alternative terminal (if ghostty not available in nixpkgs)
    alacritty
    kitty

    # Mac system utilities
    terminal-notifier

    # File system utilities
    ext4fuse  # Ext4 filesystem support

    # Mac-specific tools
    mas  # Mac App Store CLI
  ];

  # Mac-specific aliases
  home.shellAliases = {
    # macOS system aliases
    brewup = "brew update && brew upgrade && brew cleanup";
    brewc = "brew cleanup";
    brewi = "brew install";
    brews = "brew search";
    brewl = "brew list";
    brewinfo = "brew info";

    # Mac system commands
    spotoff = "sudo mdutil -a -i off";  # Turn off Spotlight
    spoton = "sudo mdutil -a -i on";    # Turn on Spotlight
    showfiles = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
    hidefiles = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
    hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
    showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";
    flushdns = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";
    lock = "pmset displaysleepnow";

    # Mac application shortcuts
    o = "open";
    oa = "open -a";
    code = "open -a 'Visual Studio Code'";
    safari = "open -a Safari";
    chrome = "open -a 'Google Chrome'";
  };

  # Mac-specific environment variables
  home.sessionVariables = {
    # Mac paths
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    HOMEBREW_REPOSITORY = "/opt/homebrew";

    # Mac-specific env
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";

    # Development
    DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer";

    # Fix ZSH config path for Mac
    ZDOTDIR = "${config.xdg.configHome}/zsh";
  };

  # Mac-specific configuration files

  # iTerm2 / Terminal preferences (optional)
  # xdg.configFile."iterm2/com.googlecode.iterm2.plist".source = ...;

  # Mac keyboard configuration (Karabiner-Elements)
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    global = {
      check_for_updates_on_startup = true;
      show_in_menu_bar = true;
      show_profile_name_in_menu_bar = false;
      profile_name_in_menu_bar_style = "ascii";
    };
    profiles = [
      {
        name = "Default";
        selected = true;
        virtual_keyboard = {
          type = "iso";
        };
        devices = [];
        manipulators = [
          # Caps Lock to Ctrl (if not already done in system)
          {
            type = "basic";
            from = {
              key_code = "caps_lock";
            };
            to = [
              {
                key_code = "left_control";
              }
            ];
            to_if_alone = [
              {
                key_code = "escape";
              }
            ];
          }
        ];
      }
    ];
  };

  # Rectangle (window management) configuration
  xdg.configFile."rectangle/RectangleConfig.json".text = builtins.toJSON {
    defaultSize = {
      width = 1440;
      height = 900;
    };
    gapSize = 16;
    centeredDirection = "center";
    shortcuts = {
      maximize = "Meta + Ctrl + M";
      leftHalf = "Meta + Ctrl + Left";
      rightHalf = "Meta + Ctrl + Right";
      topHalf = "Meta + Ctrl + Up";
      bottomHalf = "Meta + Ctrl + Down";
      topLeft = "Meta + Ctrl + U";
      topRight = "Meta + Ctrl + I";
      bottomLeft = "Meta + Ctrl + J";
      bottomRight = "Meta + Ctrl + K";
      center = "Meta + Ctrl + C";
      restore = "Meta + Ctrl + R";
    };
    subsequentExecutions = "snap";
    windowSnapping = "resize";
    unsnapRestore = "center";
  };

  # Mac defaults (system preferences)
  # These require running a script after setup
  home.file.".local/bin/mac-defaults".text = ''
    #!/usr/bin/env bash
    # macOS system preferences setup script

    # Finder preferences
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write com.apple.finder ShowExtensionsForKnownFileTypes -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Dock preferences
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock show-recents -bool false
    defaults write com.apple.dock tilesize -int 64
    defaults write com.apple.dock largesize -int 64
    defaults write com.apple.dock magnification -bool false
    defaults write com.apple.dock orientation -string "bottom"
    defaults write com.apple.dock show-process-indicators -bool true
    defaults write com.apple.dock launchanim -bool false

    # Trackpad preferences
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

    # Keyboard preferences
    defaults write -g AppleKeyboardUIMode -int 3
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g InitialKeyRepeat -int 15
    defaults write -g KeyRepeat -int 2

    # Safari preferences
    defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

    # TextEdit preferences
    defaults write com.apple.TextEdit RichText -int 0

    # Screenshots
    defaults write com.apple.screencapture location -string "${config.xdg.dataHome}/screenshots"
    defaults write com.apple.screencapture type -string "png"
    defaults write com.apple.screencapture disable-shadow -bool true

    # Hot corners (disabled)
    defaults write com.apple.dock wvous-bl-corner -int 0
    defaults write com.apple.dock wvous-br-corner -int 0
    defaults write com.apple.dock wvous-tl-corner -int 0
    defaults write com.apple.dock wvous-tr-corner -int 0

    # Time Machine
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    # Disable automatic termination of inactive apps
    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

    # Disable crash reporter
    defaults write com.apple.CrashReporter DialogType -string "none"

    # Enable Debug menu in Disk Utility
    defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true

    # Kill affected apps to apply changes
    killall Finder
    killall Dock
    killall Safari

    echo "Mac defaults applied successfully!"
  '';

  # OrbStack configuration reference (for Docker on Mac)
  home.file.".local/share/orbstack-info.md".text = ''
    # OrbStack on macOS

    OrbStack is a fast, lightweight alternative to Docker Desktop for macOS.

    ## Installation

    ```bash
    # Via Homebrew (recommended)
    brew install --cask orbstack

    # Or download directly
    # https://orbstack.dev/
    ```

    ## Features

    - Docker and Docker Compose support
    - Kubernetes support
    - Linux VM support (run any Linux distro)
    - Fast startup (~2 seconds)
    - Low memory usage
    - Native Apple Silicon support

    ## Configuration

    OrbStack configuration is stored in:
    - ~/Library/Application Support/OrbStack/

    ## Docker Compatibility

    OrbStack replaces Docker Desktop:
    - Same Docker CLI commands
    - Same Docker Compose commands
    - Docker context: "orbstack"

    ## Linux VMs

    Run Linux commands directly:
    ```bash
    orb ubuntu run "apt update"
    orb arch run "pacman -Syu"
    orb alpine run "apk update"
    ```

    ## Machine settings

    ```bash
    # Set default Linux machine
    orb config set default ubuntu

    # Set machine resources
    orb config set machine.cpus 4
    orb config set machine.memory 8GB
    ```

    ## NixOS/Linux VM

    You can run NixOS in OrbStack:
    ```bash
    orb create nixos nix
    orb nix run "nix-shell -p hello --run hello"
    ```
  '';

  # Homebrew integration reference
  home.file.".local/share/homebrew-info.md".text = ''
    # Homebrew Integration

    Homebrew is used as a backup package manager for Mac-specific GUI applications.

    ## Install Homebrew

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

    ## Setup

    Add to shell config:
    ```bash
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ```

    ## Install from Brewfile

    ```bash
    brew bundle --file=${config.xdg.configHome}/homebrew/Brewfile
    ```

    ## Apps in nixpkgs vs Homebrew

    ### Try nixpkgs first
    - Most CLI tools work well from nixpkgs
    - TUI tools work well from nixpkgs
    - Neovim, Helix, Ghostty (if available)

    ### Use Homebrew for
    - Mac-only GUI apps (OrbStack, Rectangle, etc.)
    - Apps with complex Mac-specific dependencies
    - Apps not available in nixpkgs
    - Fonts (sometimes better in Homebrew)
  '';

  # OrbStack Docker context
  home.file.".docker/config.json".text = builtins.toJSON {
    currentContext = "orbstack";
    contexts = {
      orbstack = {
        dockerHost = "unix:///Users/viryoke/.orbstack/run/docker.sock";
      };
      default = {
        dockerHost = "unix:///var/run/docker.sock";
      };
    };
  };
}
{ config, pkgs, lib, ... }:

{
  # Modern CLI tools - essential only
  home.packages = with pkgs; [
    # Better cat
    bat

    # Better grep
    ripgrep

    # Better find
    fd

    # Better ls
    eza

    # Smart cd
    zoxide

    # Better du
    dust

    # Better tree/finder
    broot

    # System monitoring
    htop
    bottom

    # Performance testing
    hyperfine

    # File monitoring
    watchexec

    # Task runner
    just

    # Code statistics
    tokei

    # JSON processing
    jq

    # Enhanced diff
    difftastic

    # HTTP client
    httpie

    # sed alternative
    sd

    # Archive tools
    p7zip
    unrar

    # File sync
    rsync

    # Trash instead of rm
    trash-cli

    # File comparison GUI
    meld

    # Disk analysis (alternative to ncdu)
    ncdu
  ];

  # Bat configuration (has built-in Dracula theme)
  programs.bat = {
    enable = true;
    config = {
      pager = "less -RF";
      theme = "Dracula";
      style = "numbers,changes,header";
      map-syntax = [
        "*.h:cpp"
        "*.conf:ini"
        "*.nix:Nix"
      ];
    };
  };

  # Eza configuration
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--hyperlink"
    ];
  };

  # Broot configuration
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      verbs = [
        {
          invocation = "edit";
          shortcut = "e";
          execution = "$EDITOR {file}";
          leave_broot = false;
        }
        {
          invocation = "open";
          shortcut = "o";
          execution = "open {file}";
          leave_broot = true;
        }
        {
          invocation = "terminal";
          shortcut = "t";
          execution = "$SHELL";
          leave_broot = false;
        }
      ];
      skin = {
        default = "rgb(248, 248, 242) none";
        tree = "rgb(98, 114, 164) none";
        file = "rgb(248, 248, 242) none";
        directory = "rgb(189, 147, 249) none Bold";
        exe = "rgb(255, 121, 198) none";
        link = "rgb(139, 233, 253) none";
        selected_line = "none rgb(68, 71, 90)";
        char_match = "rgb(255, 121, 198) none Bold";
      };
    };
  };

  # Zoxide configuration
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
}
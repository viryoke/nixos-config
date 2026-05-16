{ config, pkgs, lib, inputs, ... }:

{
  # Common imports - all modules
  imports = [
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/editor.nix
    ./modules/cli-tools.nix
    ./modules/file-manager.nix
    ./modules/python.nix
    ./modules/nodejs.nix
    ./modules/version-control.nix
    ./modules/fonts.nix
    ./modules/themes.nix
    ./modules/ai-tools.nix
    ./modules/network.nix
    ./modules/vscode.nix
    ./modules/zellij.nix
    ./modules/github.nix
  ] ++ lib.optionals (pkgs.stdenv.isLinux) [
    ./modules/wm.nix
    ./modules/display.nix
    ./modules/bar.nix
    ./modules/wallpaper.nix
    ./modules/container.nix
    ./modules/input-method.nix
    ./modules/nvidia.nix
  ];

  # Home Manager settings
  home.stateVersion = "24.11";

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # Nix configuration
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # XDG base directories
  xdg = {
    enable = true;
    configFile = {
      "nix/nix.conf".text = ''
        experimental-features = nix-command flakes
        auto-optimise-store = true
        warn-dirty = false
      '';
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
    MANPAGER = "bat --paging=always";
    NIX_PATH = "nixpkgs=channel:nixpkgs-unstable";
  };

  # Basic packages always needed (not duplicated in other modules)
  home.packages = with pkgs; [
    curl
    wget
    gnumake
    coreutils
    gnused
    gnutar
    gzip
    # unzip moved to file-manager.nix
    xz
  ];

  }
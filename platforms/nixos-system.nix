{ config, pkgs, lib, ... }:

{
  # NixOS system-level configuration
  # This is used for full NixOS system management

  imports = [
    # Home Manager is imported in flake.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Basic system utilities
    git
    curl
    wget
    vim
    htop
  ];

  # Nix configuration
  nix = {
    enable = true;
    package = pkgs.nix;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [ "root" "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Optimise store periodically
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Boot configuration
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      # Or use GRUB
      # grub = {
      #   enable = true;
      #   device = "/dev/sda";
      #   useOSProber = true;
      # };
    };

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Clean tmp on boot
    cleanTmpDir = true;
  };

  # Hardware configuration
  hardware = {
    # OpenGL
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Pulseaudio support (for Pipewire)
    pulseaudio = {
      enable = false;  # Using Pipewire instead
    };
  };

  # Networking
  networking = {
    hostName = "nixos-desktop";
    networkmanager = {
      enable = true;
    };

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];  # SSH
      allowedUDPPorts = [];
    };

    # DNS
    nameservers = [ "223.5.5.5" "119.29.29.29" ];
  };

  # Time zone
  time.timeZone = "Asia/Shanghai";

  # Locale
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Input method
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };
    };
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-sans
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono Nerd Font" "Noto Sans Mono CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # XDG portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;  # For Wayland
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Wayland
  programs.wayland = {
    enable = true;
  };

  # Display manager
  services.displayManager = {
    ly = {
      enable = true;
    };
    # Or use GDM/SDDM
    # gdm = {
    #   enable = true;
    #   wayland = true;
    # };
  };

  # Desktop environment
  # None - using Niri window manager

  # Niri
  programs.niri = {
    enable = true;
  };

  # Audio - Pipewire
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
    jack = {
      enable = true;
    };
    wireplumber = {
      enable = true;
    };
  };

  # Bluetooth
  services.blueman = {
    enable = true;
  };

  # Power management
  services = {
    # Power profiles daemon
    power-profiles-daemon = {
      enable = true;
    };

    # TLP (laptop power management)
    # tlp = {
    #   enable = true;
    # };

    # UPower
    upower = {
      enable = true;
    };

    # Auto-cpufreq (alternative)
    # auto-cpufreq = {
    #   enable = true;
    # };
  };

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # Printer drivers if needed
    ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Podman (rootless container runtime)
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # Provides docker command alias
    defaultNetwork.settings.dns_enabled = true;
  };

  # Auto-prune podman images
  systemd.services.podman-auto-prune = {
    enable = true;
    description = "Podman Auto Prune Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman system prune -f";
    };
    startsOn = "weekly";
  };

  # Users
  users.users.viryoke = {
    isNormalUser = true;
    home = "/home/viryoke";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"      # sudo
      "networkmanager"
      "docker"
      "video"
      "audio"
      "input"
      "bluetooth"
    ];
  };

  # Security
  security = {
    # Sudo
    sudo = {
      wheelNeedsPassword = true;
    };

    # Polkit
    polkit = {
      enable = true;
    };

    # AppArmor (optional)
    # apparmor = {
    #   enable = true;
    # };
  };

  # System state version
  system.stateVersion = "24.11";
}
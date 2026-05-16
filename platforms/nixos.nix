{ config, pkgs, lib, ... }:

{
  # NixOS-specific imports
  imports = [
    # All Linux modules are imported from home.nix
  ];

  # NixOS-specific packages (if any)
  home.packages = with pkgs; [
    # NixOS-specific tools
    nixos-rebuild
    nixos-option
    nixos-container
  ];

  # NixOS-specific aliases
  home.shellAliases = {
    # NixOS system aliases
    nrs = "sudo nixos-rebuild switch";
    nrt = "sudo nixos-rebuild test";
    nrb = "sudo nixos-rebuild boot";
    nrg = "sudo nixos-rebuild switch --upgrade";
    nrl = "sudo nixos-rebuild switch --rollback";
    nro = "nixos-option";

    # NixOS garbage collection
    ngc = "sudo nix-collect-garbage -d";
    ngo = "sudo nix-store --optimise";

    # Home Manager aliases
    hm = "home-manager";
    hms = "home-manager switch --flake";
    hme = "home-manager edit";
    hmb = "home-manager generations";

    # NixOS search
    ns = "nix search nixpkgs";
    nsp = "nix-shell -p";
    nf = "nix flake";

    # NixOS specific paths
    nixos-config = "cd /etc/nixos";
  };

  # NixOS-specific environment variables
  home.sessionVariables = {
    # NixOS-specific env
    NIXOS_CONFIG = "/etc/nixos";
  };

  # NixOS system configuration reference
  home.file.".local/share/nixos-system-info.md".text = ''
    # NixOS System Configuration

    ## NixOS Module Integration

    When using NixOS, you can integrate Home Manager at system level:

    ```nix
    # /etc/nixos/configuration.nix

    { config, pkgs, ... }:

    {
      imports = [
        <home-manager/nixos>
      ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.viryoke = {
        imports = [ ./home.nix ];
      };
    }
    ```

    ## Or Use Standalone Home Manager

    ```bash
    # Initialize
    nix run home-manager/master -- init

    # Apply configuration
    home-manager switch --flake ./nix-config#nixos
    ```

    ## Flakes Setup

    ```nix
    # /etc/nixos/flake.nix

    {
      inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
      };

      outputs = { self, nixpkgs, home-manager, ... }: {
        nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.viryoke = import ./home.nix;
            }
          ];
        };
      };
    }
    ```

    ## Display Manager (Ly)

    ```nix
    # Enable Ly in NixOS configuration
    services.displayManager.ly.enable = true;
    ```

    ## Niri Setup

    ```nix
    # Enable Niri in NixOS configuration
    programs.niri.enable = true;

    # Or use Flake input
    inputs.niri-flake.url = "github:sodiboo/niri-flake";
    ```

    ## Wayland Setup

    ```nix
    # Enable Wayland in NixOS
    programs.wayland.enable = true;
    services.xserver.wayland.enable = true;
    ```

    ## Pipewire Audio

    ```nix
    # Enable Pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    ```

    ## Docker Setup

    ```nix
    # Enable Docker
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      rootless.enable = true;
    };

    # Add user to docker group
    users.users.viryoke.extraGroups = [ "docker" ];
    ```

    ## Input Method (Fcitx5)

    ```nix
    # Enable Fcitx5
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-chinese-addons
      ];
    };
    ```

    ## Fonts

    ```nix
    # Configure fonts
    fonts.packages = with pkgs; [
      jetbrains-mono
      fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts-cjk
      noto-fonts-emoji
    ];
    ```

    ## Useful NixOS Commands

    ```bash
    # Rebuild system
    sudo nixos-rebuild switch

    # Upgrade system
    sudo nixos-rebuild switch --upgrade

    # Rollback to previous generation
    sudo nixos-rebuild switch --rollback

    # List generations
    nixos-rebuild list-generations

    # Clean old generations
    sudo nix-collect-garbage -d

    # Optimize store
    sudo nix-store --optimise

    # Query NixOS options
    nixos-option services.pipewire.enable

    # Search packages
    nix search nixpkgs firefox

    # Build package
    nix build nixpkgs#firefox

    # Run package
    nix run nixpkgs#firefox
    ```

    ## NixOS Wiki

    - https://nixos.wiki/wiki/Home_Manager
    - https://nixos.wiki/wiki/Flakes
    - https://nixos.wiki/wiki/Pipewire
    - https://nixos.wiki/wiki/Docker
    - https://nixos.wiki/wiki/Input_method
    - https://nixos.wiki/wiki/Fonts
  '';
}
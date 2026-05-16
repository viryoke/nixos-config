{
  description = "Cross-platform Nix configuration for unified workflow";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri window manager (Linux only)
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim plugins and config
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nix-darwin, niri-flake, neovim-nightly-overlay, ... }@inputs:
    let
      # Helper function to create Home Manager configurations
      mkHomeConfig = { system, hostname, username, extraModules ? [] }:
        let
          isLinux = system == "x86_64-linux";
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
              allowBroken = true;
            };
            overlays = [
              niri-flake.overlays.niri
              neovim-nightly-overlay.overlays.default
            ];
          };
          extraSpecialArgs = { inherit inputs isLinux; };
          modules = [
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = if system == "aarch64-darwin" || system == "x86_64-darwin"
                then "/Users/${username}"
                else "/home/${username}";
            }
          ] ++ extraModules;
        };

      # Helper function for Darwin (Mac) system configurations
      mkDarwinConfig = { system, hostname, username }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs; isLinux = false; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports = [ ./home.nix ./platforms/mac.nix ];
                home.username = username;
                home.homeDirectory = "/Users/${username}";
              };
            }
            ./platforms/darwin-system.nix
          ];
        };

      # Supported systems
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      # Generate attributes for all systems
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Home Manager configurations (standalone, for non-NixOS Linux)
      homeConfigurations = {
        # Ubuntu
        ubuntu = mkHomeConfig {
          system = "x86_64-linux";
          hostname = "ubuntu";
          username = "viryoke";
          extraModules = [ ./platforms/ubuntu.nix ];
        };

        # Arch Linux
        arch = mkHomeConfig {
          system = "x86_64-linux";
          hostname = "arch";
          username = "viryoke";
          extraModules = [ ./platforms/arch.nix ];
        };

        # NixOS (using standalone HM for user config)
        nixos = mkHomeConfig {
          system = "x86_64-linux";
          hostname = "nixos";
          username = "viryoke";
          extraModules = [ ./platforms/nixos.nix ];
        };

        # Mac (standalone Home Manager, alternative to darwin config)
        mac = mkHomeConfig {
          system = "aarch64-darwin";
          hostname = "mac";
          username = "viryoke";
          extraModules = [ ./platforms/mac.nix ];
        };
      };

      # Darwin (Mac) system configurations (full system management)
      darwinConfigurations = {
        macbook = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "macbook";
          username = "viryoke";
        };
      };

      # NixOS configurations (for NixOS system)
      nixosConfigurations = {
        nixos-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; isLinux = true; };
          modules = [
            ./platforms/nixos-system.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.viryoke = {
                imports = [ ./home.nix ./platforms/nixos.nix ];
              };
            }
          ];
        };
      };

      # Export packages for convenience
      packages = forAllSystems (system: {
        default = home-manager.packages.${system}.default;
      });

      # Development shell
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nix
            home-manager
            git
          ];
        };
      });
    };
}
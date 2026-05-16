{ config, pkgs, lib, ... }:

{
  # Ubuntu-specific imports
  imports = [
    # All Linux modules are imported from home.nix
  ];

  # Ubuntu-specific packages (if any)
  home.packages = with pkgs; [
    # Ubuntu-specific system tools if needed
  ];

  # Ubuntu-specific aliases
  home.shellAliases = {
    # Ubuntu system aliases
    aptup = "sudo apt update && sudo apt upgrade";
    apti = "sudo apt install";
    aptr = "sudo apt remove";
    aptc = "sudo apt autoremove && sudo apt autoclean";
    aptl = "apt list --installed";
    aptsearch = "apt search";
    aptinfo = "apt show";

    # Ubuntu-specific paths
    logs = "cd /var/log";
    www = "cd /var/www";
  };

  # Ubuntu-specific environment variables
  home.sessionVariables = {
    # Ubuntu-specific env
  };

  # Ubuntu system configuration reference
  home.file.".local/share/ubuntu-system-info.md".text = ''
    # Ubuntu System Configuration

    ## Installing Nix on Ubuntu

    ```bash
    # Single-user installation
    sh <(curl -L https://nixos.org/nix/install) --no-daemon

    # Multi-user installation (recommended)
    sh <(curl -L https://nixos.org/nix/install) --daemon
    ```

    ## Home Manager Setup

    ```bash
    # Install Home Manager
    nix run home-manager/master -- init

    # Apply configuration
    home-manager switch --flake ./nix-config#ubuntu
    ```

    ## Display Manager (Ly)

    Ly needs to be installed at system level:
    ```bash
    # Build from source or use package
    sudo apt install ly  # if available
    # Or build from AUR
    ```

    ## Niri Installation

    Niri should be installed via Nix:
    ```bash
    # Already configured in modules/wm.nix
    ```

    ## Docker Setup

    ```bash
    # Install Docker
    sudo apt install docker.io docker-compose

    # Add user to docker group
    sudo usermod -aG docker $USER

    # Enable Docker
    sudo systemctl enable docker
    sudo systemctl start docker
    ```

    ## Required System Packages

    Some packages might need system-level installation:
    ```bash
    sudo apt install \
      build-essential \
      pkg-config \
      libssl-dev \
      libffi-dev \
      python3-dev \
      libgtk-3-dev \
      libnotify-dev \
      libxkbcommon-dev
    ```

    ## Wayland Setup

    Ubuntu 22.04+ supports Wayland:
    - Select "Ubuntu on Wayland" at login
    - Or enable manually: `/etc/gdm3/custom.conf`
    ```ini
    [Daemon]
    WaylandEnable=true
    ```

    ## Input Method (Fcitx5)

    ```bash
    sudo apt install fcitx5 fcitx5-mozc fcitx5-chinese-addons
    im-config -n fcitx5
    ```
  '';
}
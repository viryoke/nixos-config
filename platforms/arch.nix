{ config, pkgs, lib, ... }:

{
  # Arch-specific imports
  imports = [
    # All Linux modules are imported from home.nix
  ];

  # Arch-specific packages (if any)
  home.packages = with pkgs; [
    # Arch-specific system tools if needed
  ];

  # Arch-specific aliases
  home.shellAliases = {
    # Arch/Pacman aliases
    pacup = "sudo pacman -Syu";
    paci = "sudo pacman -S";
    pacr = "sudo pacman -Rns";
    pacss = "pacman -Ss";
    pacqi = "pacman -Qi";
    pacql = "pacman -Ql";
    pacorphans = "pacman -Qtdq";
    paclean = "sudo pacman -Sc && sudo pacman -Rns $(pacman -Qtdq)";
    paccache = "sudo pacman -Sc";

    # AUR helper aliases (if using yay/paru)
    yayup = "yay -Syu";
    yayi = "yay -S";
    yayr = "yay -Rns";
    yayss = "yay -Ss";
    yayqi = "yay -Qi";
    yayc = "yay -c";

    paruup = "paru -Syu";
    parui = "paru -S";
    parur = "paru -Rns";
    paruss = "paru -Ss";
    paruqi = "paru -Qi";
    paruc = "paru -c";

    # Arch-specific paths
    logs = "cd /var/log";
    pacman-cache = "cd /var/cache/pacman/pkg";
  };

  # Arch-specific environment variables
  home.sessionVariables = {
    # Arch-specific env
  };

  # Arch system configuration reference
  home.file.".local/share/arch-system-info.md".text = ''
    # Arch Linux System Configuration

    ## Installing Nix on Arch

    ```bash
    # Install via pacman
    sudo pacman -S nix

    # Or use AUR for latest version
    yay -S nix-package-manager

    # Enable nix-daemon
    sudo systemctl enable nix-daemon
    sudo systemctl start nix-daemon

    # Add to trusted users
    sudo usermod -aG nix-users $USER
    ```

    ## Home Manager Setup

    ```bash
    # Initialize Home Manager
    nix run home-manager/master -- init

    # Apply configuration
    home-manager switch --flake ./nix-config#arch
    ```

    ## Required System Packages

    ```bash
    sudo pacman -S --needed \
      base-devel \
      git \
      curl \
      wget \
      pkg-config \
      openssl \
      gtk3 \
      libnotify \
      libxkbcommon \
      wayland \
      wayland-protocols \
      libinput \
      pulseaudio \
      pipewire \
      pipewire-pulse \
      wireplumber \
      bluez \
      bluez-utils \
      networkmanager
    ```

    ## Display Manager (Ly)

    Install Ly from AUR:
    ```bash
    yay -S ly

    # Enable Ly
    sudo systemctl enable ly
    sudo systemctl start ly
    ```

    ## Niri Setup

    Niri is installed via Nix Flake (modules/wm.nix).

    Or install from AUR:
    ```bash
    yay -S niri
    ```

    ## Wayland Setup

    Arch has excellent Wayland support:
    - Install Wayland packages
    - Configure environment variables
    - Use niri as window manager

    ## Docker Setup

    ```bash
    sudo pacman -S docker docker-compose
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    ```

    ## Input Method (Fcitx5)

    ```bash
    sudo pacman -S fcitx5-im fcitx5-mozc fcitx5-chinese-addons
    # Add to environment variables
    GTK_IM_MODULE=fcitx
    QT_IM_MODULE=fcitx
    XMODIFIERS=@im=fcitx
    SDL_IM_MODULE=fcitx
    INPUT_METHOD=fcitx
    ```

    ## Sound (Pipewire)

    ```bash
    sudo pacman -S pipewire pipewire-pulse wireplumber
    systemctl --user enable pipewire pipewire-pulse wireplumber
    systemctl --user start pipewire pipewire-pulse wireplumber
    ```

    ## Bluetooth

    ```bash
    sudo pacman -S bluez bluez-utils
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth
    ```

    ## Networking

    ```bash
    sudo pacman -S networkmanager
    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
    ```

    ## Useful Arch Commands

    ```bash
    # Check package ownership of file
    pacman -Qo /path/to/file

    # Check which package provides a command
    pacman -Fy  # Update files database
    pacman -F /usr/bin/command

    # Clean orphan packages
    pacman -Rns $(pacman -Qtdq)

    # Check package dependencies
    pactree package_name

    # Check reverse dependencies
    pactree -r package_name
    ```

    ## Arch Wiki References

    - https://wiki.archlinux.org/title/Nix
    - https://wiki.archlinux.org/title/Wayland
    - https://wiki.archlinux.org/title/Pipewire
    - https://wiki.archlinux.org/title/Docker
    - https://wiki.archlinux.org/title/Input_method
  '';
}
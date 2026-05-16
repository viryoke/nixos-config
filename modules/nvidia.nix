{ config, pkgs, lib, ... }:

{
  # NVIDIA Graphics Driver Configuration (Linux only)
  # Note: This requires system-level configuration on NixOS
  # For Ubuntu/Arch, this provides reference information

  home.file.".local/share/nvidia-nixos-config.nix".text = ''
    # NixOS NVIDIA Driver Configuration
    # Add this to your /etc/nixos/configuration.nix

    {
      # Enable NVIDIA drivers
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = false;  # Use proprietary drivers (more stable)
        nvidiaSettings = true;  # Install nvidia-settings tool
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # For newer GPUs (RTX 2000+ series), you might want:
        # package = config.boot.kernelPackages.nvidiaPackages.production;

        # For older GPUs, you might need specific versions:
        # package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
        # package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
      };

      # X11/Wayland configuration
      services.xserver.videoDrivers = [ "nvidia" ];

      # OpenGL configuration
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;  # For 32-bit apps/games
        extraPackages = with pkgs; [
          nvidia-vaapi-driver  # VAAPI support for NVIDIA
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      # Environment variables for NVIDIA
      environment.sessionVariables = {
        # Wayland support
        LIB_SEAT = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";

        # VA-API for hardware video decoding
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";

        # Firefox/Chromium hardware acceleration
        MOZ_DISABLE_RIO = "1";

        # NVIDIA-specific
        NVIDIA_VISIBLE_DEVICES = "all";
        NVIDIA_DRIVER_CAPABILITIES = "all";

        # Fix flickering on Wayland
        __GL_GSYNC_ALLOWED = "1";
        __GL_VSYNC_ALLOWED = "1";

        # Performance
        __GL_THREADED_OPTIMIZATION = "1";
      };

      # Fix for Wayland + NVIDIA
      boot.kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia-drm.modeset=1"
      ];

      # systemd services for NVIDIA power management
      systemd.services.nvidia-suspend = {
        enable = true;
        description = "NVIDIA Systemd Suspend Service";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.nvidia-utils}/bin/nvidia-suspend";
        };
        wantedBy = [ "sleep.target" ];
      };

      systemd.services.nvidia-hibernate = {
        enable = true;
        description = "NVIDIA Systemd Hibernate Service";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.nvidia-utils}/bin/nvidia-hibernate";
        };
        wantedBy = [ "sleep.target" ];
      };

      systemd.services.nvidia-resume = {
        enable = true;
        description = "NVIDIA Systemd Resume Service";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.nvidia-utils}/bin/nvidia-resume";
        };
        wantedBy = [ "suspend.target" "hibernate.target" ];
      };

      # Add user to video group
      users.users.viryoke.extraGroups = [ "video" ];
    }
  '';

  # NVIDIA-related packages (user level)
  home.packages = with pkgs; [
    # NVIDIA monitoring and control tools
    nvtop  # NVIDIA GPU monitoring (like htop for GPUs)
    nvidia-smi  # Built-in, but ensure it's available

    # GPU information tools
    gpu-viewer
    glxinfo  # OpenGL info
    vulkan-tools  # Vulkan info

    # Benchmarking
    glmark2  # OpenGL benchmark
    vkmark  # Vulkan benchmark (if available)

    # Temperature monitoring
    nvidia-temperature-monitor

    # Video encoding with NVENC
    # These are typically system-level but useful to have
  ];

  # NVIDIA aliases
  home.shellAliases = {
    nvidia-smi = "nvidia-smi";
    nvidia-temp = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader";
    nvidia-mem = "nvidia-smi --query-gpu=memory.used,memory.total --format=csv";
    nvidia-power = "nvidia-smi --query-gpu=power.draw --format=csv,noheader";
    nvidia-clock = "nvidia-smi --query-gpu=clocks.current.graphics,clocks.current.memory --format=csv";
    nvidia-info = "nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv";
    nvtop = "nvtop";
    gpu-info = "glxinfo | grep 'OpenGL renderer'";
  };

  # NVIDIA power management script
  home.file.".local/bin/nvidia-power".text = ''
    #!/usr/bin/env bash
    # NVIDIA power management script

    case "$1" in
      status)
        nvidia-smi --query-gpu=power.draw,temperature.gpu,clocks.current.graphics --format=csv,noheader,nounits
        ;;
      perf)
        # Set performance mode
        nvidia-smi -i 0 -pl $2  # Power limit
        ;;
      clocks)
        # Lock GPU clocks (for stability)
        nvidia-smi -i 0 -lgc $2  # Lock graphics clock
        ;;
      reset)
        nvidia-smi -r  # Reset GPU
        ;;
      *)
        echo "Usage: nvidia-power {status|perf W|clocks MHz|reset}"
        ;;
    esac
  '';

  # NVIDIA Wayland integration info
  home.file.".local/share/nvidia-wayland-info.md".text = ''
    # NVIDIA + Wayland Integration

    ## Requirements
    - NVIDIA driver 515+ (recommended 535+)
    - Kernel 5.10+ (recommended 6.0+)
    - Wayland compositor with NVIDIA support

    ## Compatible Compositors

    ### Niri (Recommended)
    Niri has good NVIDIA support:
    - Add to niri config: environment { __GLX_VENDOR_LIBRARY_NAME "nvidia" }
    - Works with direct scanout

    ### Hyprland
    Works but requires:
    - env = GBM_BACKEND,nvidia-drm
    - env = __GLX_VENDOR_LIBRARY_NAME,nvidia

    ### Sway
    Basic support, may have flickering

    ## Firefox Hardware Acceleration
    Set in about:config:
    - gfx.webrender.all = true
    - media.hardware-video-decoding.enabled = true
    - media.ffmpeg.vaapi.enabled = true

    ## Common Issues

    ### Flickering
    - Enable __GL_GSYNC_ALLOWED and __GL_VSYNC_ALLOWED
    - Use modesetting driver

    ### Performance
    - Enable threaded optimization: __GL_THREADED_OPTIMIZATION=1
    - Use NVENC for video encoding

    ### Sleep/Hibernate
    - Enable PreserveVideoMemoryAllocations kernel parameter
    - Use nvidia-suspend/hibernate/resume services
  '';

  # Ubuntu/Arch NVIDIA installation reference
  home.file.".local/share/nvidia-linux-info.md".text = ''
    # NVIDIA Driver Installation

    ## Ubuntu
    ```bash
    # Recommended method
    sudo ubuntu-drivers install

    # Or manually
    sudo apt install nvidia-driver-535  # Latest stable

    # Verify
    nvidia-smi
    ```

    ## Arch Linux
    ```bash
    # Install NVIDIA driver
    sudo pacman -S nvidia nvidia-utils

    # For 32-bit support (games)
    sudo pacman -S lib32-nvidia-utils

    # Install CUDA toolkit (optional)
    sudo pacman -S cuda cudnn

    # Add to mkinitcpio.conf
    MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

    # Regenerate initramfs
    sudo mkinitcpio -P

    # Add kernel parameters to bootloader
    # GRUB: /etc/default/grub
    GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    # Verify
    nvidia-smi
    ```

    ## Performance Tips

    ### Power Management
    ```bash
    # Enable power management
    sudo nvidia-smi -pm 1

    # Set power limit (e.g., 200W)
    sudo nvidia-smi -pl 200
    ```

    ### Fan Control
    ```bash
    # Manual fan control
    sudo nvidia-smi -i 0 -gpu-fan-control-enable
    sudo nvidia-smi -i 0 -gfc 60  # Set to 60%
    ```

    ### Overclocking (optional)
    ```bash
    # Enable coolbits
    sudo nvidia-xconfig --cool-bits=28

    # Then use nvidia-settings to adjust
    ```

    ## Monitoring
    ```bash
    # Watch GPU stats
    watch -n 1 nvidia-smi

    # Or use nvtop
    nvtop
    ```

    ## Troubleshooting
    - Check logs: journalctl -k | grep -i nvidia
    - Verify driver: nvidia-smi -q | head
    - Test OpenGL: glxinfo | grep NVIDIA
  '';
}
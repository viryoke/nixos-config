{ config, pkgs, lib, isLinux, ... }:

lib.mkIf isLinux {
  # NVIDIA Graphics Driver Configuration (Linux only)
  # Note: This requires system-level configuration on NixOS
  # For Ubuntu/Arch, this provides reference information

  # NVIDIA-related packages (user level)
  home.packages = with pkgs; [
    # NVIDIA monitoring tools
    nvitop  # NVIDIA GPU monitoring (Python-based)
    btop    # System monitor with GPU support

    # GPU information tools
    mesa-demos  # OpenGL info (includes glxinfo)
    vulkan-tools  # Vulkan info

    # Benchmarking
    glmark2  # OpenGL benchmark
  ];

  # NVIDIA aliases
  home.shellAliases = {
    nvidia-temp = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader";
    nvidia-mem = "nvidia-smi --query-gpu=memory.used,memory.total --format=csv";
    nvidia-power = "nvidia-smi --query-gpu=power.draw --format=csv,noheader";
    nvidia-clock = "nvidia-smi --query-gpu=clocks.current.graphics,clocks.current.memory --format=csv";
    nvidia-info = "nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv";
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

  # Reference file for NixOS NVIDIA configuration
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
      };

      # X11/Wayland configuration
      services.xserver.videoDrivers = [ "nvidia" ];

      # OpenGL configuration
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;  # For 32-bit apps/games
      };

      # Environment variables for NVIDIA
      environment.sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VSYNC_ALLOWED = "1";
        __GL_THREADED_OPTIMIZATION = "1";
      };

      # Fix for Wayland + NVIDIA
      boot.kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia-drm.modeset=1"
      ];
    }
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
  '';
}
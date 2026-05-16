{ config, pkgs, lib, inputs, ... }:

{
  # Niri window manager

  # Niri configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration

    // Input settings
    input {
      keyboard {
        repeat-rate 50
        repeat-delay 200
        xkb {
          layout "us"
          options "ctrl:nocaps"
        }
      }

      touchpad {
        tap true
        dwt true
        natural-scroll true
        accel-profile "adaptive"
        scroll-speed 0.8
      }

      mouse {
        accel-profile "adaptive"
        natural-scroll false
      }
    }

    // Output settings
    output "eDP-1" {
      scale 1.0
      position x=0 y=0
    }

    // Spawn at startup
    spawn-at-startup [
      { command ["waybar"] }
      { command ["hyprpaper"] }
      { command ["mako"] }
    ]

    // Environment variables
    environment {
      QT_QPA_PLATFORM "wayland"
      XDG_CURRENT_DESKTOP "niri"
      XDG_SESSION_TYPE "wayland"
    }

    // Cursor settings
    cursor {
      xcursor-theme "Bibata-Modern-Ice"
      xcursor-size 24
    }

    // Layout settings
    layout {
      gaps 16
      center-focused-column true
      preset-column-widths [
        { proportion 0.3333 }
        { proportion 0.5 }
        { proportion 0.6667 }
      ]
      default-column-width { proportion 0.5 }
      struts {
        left 64
        right 64
        top 64
        bottom 64
      }
      focus-ring {
        off
      }
      border {
        on
        width 2
        active-color "#bd93f9"
        inactive-color "#44475a"
      }
    }

    // Window rules with transparency
    window-rules [
      {
        match app-id="^(ghostty|Alacritty|kitty|foot)$"
        opacity 0.9
      }
      {
        match app-id="^(code|Code|vscode)$"
        opacity 0.9
      }
    ]

    // Keybindings
    bindings {
      // Focus navigation
      Mod+Left { focus-column-left; }
      Mod+Down { focus-window-down; }
      Mod+Up { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }

      // Window movement
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+Down { move-window-down; }
      Mod+Shift+Up { move-window-up; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }
      Mod+Shift+L { move-column-right; }

      // Column width
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-column-width "-1%"; }
      Mod+Shift+Equal { set-column-width "+1%"; }
      Mod+Ctrl+1 { set-column-width "33%"; }
      Mod+Ctrl+2 { set-column-width "50%"; }
      Mod+Ctrl+3 { set-column-width "66%"; }
      Mod+Ctrl+4 { set-column-width "100%"; }

      // Window actions
      Mod+Shift+F { fullscreen-window; }
      Mod+F { toggle-windowed-fullscreen; }
      Mod+C { center-column; }
      Mod+X { close-window; }

      // Workspace navigation
      Mod+Tab { focus-workspace-down; }
      Mod+Shift+Tab { focus-workspace-up; }
      Mod+1..9 { focus-workspace 1..9; }
      Mod+Shift+1..9 { move-column-to-workspace 1..9; }

      // Applications
      Mod+Return { spawn "ghostty"; }
      Mod+Space { spawn "fuzzel"; }

      // Screenshot
      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Shift+Print { screenshot-area; }

      // Media keys
      XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
      XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86MonBrightnessUp { spawn "brightnessctl" "set" "+5%"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
      XF86AudioPlay { spawn "playerctl" "play-pause"; }
      XF86AudioNext { spawn "playerctl" "next"; }
      XF86AudioPrev { spawn "playerctl" "previous"; }

      // Lock screen
      Mod+Escape { spawn "swaylock"; }

      // Quit
      Mod+Q { quit; }
    }
  '';

  # Essential utilities for window management
  home.packages = with pkgs; [
    # Niri window manager
    niri

    # Launcher
    fuzzel

    # Clipboard
    cliphist
    wl-clipboard

    # Screenshots
    grim
    slurp

    # Screen lock
    swaylock
    swayidle

    # Notification daemon
    mako

    # Player control
    playerctl
  ];

  # Swaylock configuration (Dracula theme)
  xdg.configFile."swaylock/config".text = ''
    daemonize
    ignore-empty-password
    color=282a36
    inside-color=282a36
    ring-color=44475a
    line-color=f8f8f2
    text-color=f8f8f2
    key-hl-color=50fa7b
    bs-hl-color=ff5555
  '';

  # Swayidle configuration
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
    };
    timeouts = [
      { timeout = 180; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      { timeout = 300; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };

  # Clipboard history service (cliphist)
  systemd.user.services = lib.mkIf pkgs.stdenv.isLinux {
    cliphist = {
      Unit = {
        Description = "Clipboard History Service";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  # Clipboard aliases
  home.shellAliases = {
    cb-list = "cliphist list";
    cb-clear = "cliphist clear";
    cb-select = "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
  };
}
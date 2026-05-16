{ config, pkgs, lib, ... }:

{
  # Waybar configuration
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 8;
        margin-top = 8;
        margin-left = 16;
        margin-right = 16;

        modules-left = [
          "custom/niri"
          "niri/window"
          "niri/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "backlight"
        ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "○";
            focused = "●";
            active = "◐";
          };
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
        };

        "custom/niri" = {
          format = " ";
          tooltip = false;
          on-click = "fuzzel";
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = " ";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pamixer --toggle-mute";
          on-click-right = "pavucontrol";
        };

        network = {
          format-wifi = "{signalStrength}% ";
          format-ethernet = "{ipaddr} 󰈀";
          format-disconnected = " 󰖪";
        };

        cpu = {
          format = "{usage}% ";
          interval = 2;
        };

        memory = {
          format = "{}% 󰘚";
          interval = 2;
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-icons = [ "󰂃" "󰂂" "󰂁" "󰂀" "󰁿" "󰁾" "󰁽" "󰁼" "󰁻" "󰁺" "󰁹" ];
        };
      };
    };

    style = ''
      /* Waybar style - Dracula Theme */

      * {
        font-family: "JetBrains Mono NF";
        font-size: 14px;
        font-weight: bold;
      }

      window#waybar {
        background: transparent;
        color: #f8f8f2;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6272a4;
      }

      #workspaces button.active {
        color: #bd93f9;
      }

      #window, #clock, #battery, #cpu, #memory, #network, #pulseaudio, #backlight, #tray {
        margin: 0 8px;
        padding: 0 8px;
        background: #282a36;
        border: 1px solid #44475a;
        border-radius: 8px;
      }

      #clock { color: #bd93f9; }
      #battery.charging { color: #50fa7b; }
      #battery.warning { color: #ffb86c; }
      #battery.critical { color: #ff5555; }
      #cpu { color: #8be9fd; }
      #memory { color: #ff79c6; }
      #network.wifi { color: #50fa7b; }
      #network.disconnected { color: #ff5555; }
      #pulseaudio.muted { color: #ff5555; }
      #pulseaudio { color: #bd93f9; }
      #backlight { color: #ffb86c; }
      #tray { color: #f8f8f2; }
    '';
  };

  # Essential status bar utilities
  home.packages = with pkgs; [
    # Audio control
    pamixer
    pavucontrol

    # Brightness
    brightnessctl

    # System sensors
    lm_sensors

    # Battery info
    upower
  ];
}
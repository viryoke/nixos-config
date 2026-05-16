{ config, pkgs, lib, ... }:

{
  # Hyprpaper - Wallpaper utility
  home.packages = with pkgs; [
    hyprpaper
  ];

  # Hyprpaper configuration
  xdg.configFile."hyprpaper/hyprpaper.conf".text = ''
    # Hyprpaper configuration

    # Wallpaper paths
    preload = ${config.xdg.dataHome}/wallpapers/1.jpg
    preload = ${config.xdg.dataHome}/wallpapers/2.jpg
    preload = ${config.xdg.dataHome}/wallpapers/3.jpg

    # Default wallpaper for each monitor
    wallpaper = eDP-1,${config.xdg.dataHome}/wallpapers/1.jpg
    wallpaper = HDMI-A-1,${config.xdg.dataHome}/wallpapers/2.jpg
    wallpaper = DP-1,${config.xdg.dataHome}/wallpapers/3.jpg

    # Default wallpaper if monitor not specified
    wallpaper = ,${config.xdg.dataHome}/wallpapers/1.jpg

    # Splash configuration
    splash = false
    splash_offset = 2.0
  '';

  # Wallpaper directory
  home.file = {
    "${config.xdg.dataHome}/wallpapers/.keep".text = "";
  };

  # Wallpaper management script
  home.file.".local/bin/wallpaper-set".text = ''
    #!/usr/bin/env bash
    # Wallpaper management script

    WALLPAPER_DIR="${config.xdg.dataHome}/wallpapers"
    CURRENT_WALLPAPER_FILE="${config.xdg.stateHome}/current-wallpaper"

    list_wallpapers() {
      ls "$WALLPAPER_DIR"/*.jpg "$WALLPAPER_DIR"/*.png 2>/dev/null | sort
    }

    set_wallpaper() {
      local wallpaper="$1"
      if [[ -f "$wallpaper" ]]; then
        hyprpaper unload all
        hyprpaper preload "$wallpaper"
        hyprpaper wallpaper eDP-1,"$wallpaper"
        echo "$wallpaper" > "$CURRENT_WALLPAPER_FILE"
        echo "Wallpaper set: $wallpaper"
      else
        echo "Wallpaper not found: $wallpaper"
        echo "Available wallpapers:"
        list_wallpapers
      fi
    }

    random_wallpaper() {
      local wallpapers
      wallpapers=$(list_wallpapers)
      if [[ -n "$wallpapers" ]]; then
        local random_wall
        random_wall=$(echo "$wallpapers" | shuf -n 1)
        set_wallpaper "$random_wall"
      else
        echo "No wallpapers found in $WALLPAPER_DIR"
      fi
    }

    case "$1" in
      list)
        list_wallpapers
        ;;
      set)
        set_wallpaper "$2"
        ;;
      random)
        random_wallpaper
        ;;
      current)
        cat "$CURRENT_WALLPAPER_FILE" 2>/dev/null || echo "No wallpaper set"
        ;;
      download)
        echo "Downloading wallpaper from: $2"
        wget -O "$WALLPAPER_DIR/custom.jpg" "$2"
        set_wallpaper "$WALLPAPER_DIR/custom.jpg"
        ;;
      *)
        echo "Usage: wallpaper-set {list|set FILE|random|current|download URL}"
        ;;
    esac
  '';

  # Wallpaper aliases
  home.shellAliases = {
    wp-list = "wallpaper-set list";
    wp-set = "wallpaper-set set";
    wp-random = "wallpaper-set random";
    wp-current = "wallpaper-set current";
  };

  # Autostart wallpaper with systemd
  systemd.user.services = {
    hyprpaper = {
      Unit = {
        Description = "Hyprpaper Wallpaper Service";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper -c ${config.xdg.configHome}/hyprpaper/hyprpaper.conf";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
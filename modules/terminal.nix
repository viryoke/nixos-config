{ config, pkgs, lib, ... }:

{
  # Ghostty terminal emulator (has built-in Dracula theme)
  home.packages = with pkgs; [
    ghostty
  ];

  # Ghostty configuration - uses built-in Dracula theme
  xdg.configFile."ghostty/config".text = ''
    # Font configuration
    font-family = "JetBrains Mono NF"
    font-size = 14
    font-thicken = true
    font-feature = +liga

    # Use built-in Dracula theme
    theme = "dracula"

    # Transparency and blur
    background-opacity = 0.9
    background-blur-radius = 20

    # Window settings
    window-padding-x = 10
    window-padding-y = 10
    window-theme = "auto"
    window-decoration = true
    window-save-state = "always"

    # Cursor
    cursor-style = "block"
    cursor-style-blink = false

    # Shell
    command = "${pkgs.zsh}/bin/zsh"

    # Keybinds
    keybind = ctrl+t=new_tab
    keybind = ctrl+w=close_surface
    keybind = ctrl+shift+t=restore_tab
    keybind = ctrl+shift+tab=previous_tab
    keybind = ctrl+tab=next_tab
    keybind = ctrl+shift+left=previous_tab
    keybind = ctrl+shift+right=next_tab
    keybind = ctrl+enter=split:new_horizontal
    keybind = ctrl+shift+enter=split:new_vertical
    keybind = ctrl+alt+left=goto_split:left
    keybind = ctrl+alt+right=goto_split:right
    keybind = ctrl+alt+up=goto_split:up
    keybind = ctrl+alt+down=goto_split:down
    keybind = ctrl+shift+resize_up=resize_split:up,10
    keybind = ctrl+shift+resize_down=resize_split:down,10
    keybind = ctrl+shift+resize_left=resize_split:left,10
    keybind = ctrl+shift+resize_right=resize_split:right,10
    keybind = ctrl+c=copy_to_clipboard
    keybind = ctrl+shift+v=paste_from_clipboard
    keybind = ctrl+shift+minus=font_size:decrease:1
    keybind = ctrl+shift+plus=font_size:increase:1
    keybind = ctrl+shift+0=font_size:reset

    # Performance
    app-notifications = no-clipboard-access

    # Misc
    mouse-hide-while-typing = true
    clipboard-read = allow
    clipboard-write = allow
  '';
}
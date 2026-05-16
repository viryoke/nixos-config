{ config, pkgs, lib, ... }:

{
  # Zellij - Terminal multiplexer (alternative to tmux)
  home.packages = with pkgs; [
    zellij
  ];

  # Zellij configuration
  xdg.configFile."zellij/config.kdl".text = ''
    // Zellij configuration

    // General settings
    session_serialization false
    pane_viewport_serialization false
    scrollback_lines_to_serialize 10000
    tab_name_width 20
    auto_layout true
    default_layout "default"
    default_shell "${pkgs.zsh}/bin/zsh"
    keybinds_clear_default true
    simplified_ui true

    // Theme
    theme "dracula"

    // Pane settings
    pane_frames true
    pane_frame_content_left_separator ""
    pane_frame_content_right_separator ""
    pane_frame_content_middle_separator " "
    pane_frame_left_separator "│"
    pane_frame_right_separator "│"
    pane_frame_top_separator "─"
    pane_frame_bottom_separator "─"
    pane_frame_top_left_separator "┌"
    pane_frame_top_right_separator "┐"
    pane_frame_bottom_left_separator "└"
    pane_frame_bottom_right_separator "┘"

    // Mouse settings
    mouse_mode true
    scroll_buffer_lines 10000
    copy_command "wl-copy"

    // Plugins
    plugins {
        tab-bar { path "tab-bar"; }
        status-bar { path "status-bar"; }
        strider { path "strider"; }
        compact-bar { path "compact-bar"; }
    }

    // Keybinds - Normal mode
    keybinds normal {
        bind "Ctrl t" { NewTab; SwitchToMode "normal"; }
        bind "Ctrl w" { CloseTab; SwitchToMode "normal"; }
        bind "Ctrl h" { MoveFocus "left"; }
        bind "Ctrl l" { MoveFocus "right"; }
        bind "Ctrl j" { MoveFocus "down"; }
        bind "Ctrl k" { MoveFocus "up"; }
        bind "Ctrl d" { HalfPageScrollDown; }
        bind "Ctrl u" { HalfPageScrollUp; }
        bind "Ctrl n" { NewPane "down"; SwitchToMode "normal"; }
        bind "Ctrl p" { NewPane "right"; SwitchToMode "normal"; }
        bind "Ctrl x" { CloseFocus; SwitchToMode "normal"; }
        bind "Ctrl f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
        bind "Ctrl s" { SwitchToMode "scroll"; }
        bind "Ctrl r" { SwitchToMode "resize"; }
        bind "Tab" { ToggleTab; }
        bind "Alt 1..9" { GoToTab 1..9; SwitchToMode "normal"; }
    }

    // Keybinds - Resize mode
    keybinds resize {
        bind "h" { Resize "Increase left"; }
        bind "j" { Resize "Increase down"; }
        bind "k" { Resize "Increase up"; }
        bind "l" { Resize "Increase right"; }
        bind "H" { Resize "Decrease left"; }
        bind "J" { Resize "Decrease down"; }
        bind "K" { Resize "Decrease up"; }
        bind "L" { Resize "Decrease right"; }
        bind "Esc" { SwitchToMode "normal"; }
    }

    // Keybinds - Scroll mode
    keybinds scroll {
        bind "e" { EditScrollback; SwitchToMode "normal"; }
        bind "/" { SwitchToMode "search"; }
        bind "j" "Down" { ScrollDown; }
        bind "k" "Up" { ScrollUp; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
        bind "Esc" { SwitchToMode "normal"; }
    }

    // Keybinds - Search mode
    keybinds search {
        bind "n" { Search "down"; }
        bind "N" { Search "up"; }
        bind "c" { SearchToggleOption "CaseSensitivity"; }
        bind "w" { SearchToggleOption "Wrap"; }
        bind "o" { SearchToggleOption "WholeWord"; }
        bind "Esc" { SwitchToMode "scroll"; }
    }
  '';

  # Zellij Dracula theme
  xdg.configFile."zellij/themes/dracula.kdl".text = ''
    themes {
        dracula {
            bg "#282a36"
            fg "#f8f8f2"
            red "#ff5555"
            green "#50fa7b"
            yellow "#f1fa8c"
            blue "#bd93f9"
            magenta "#ff79c6"
            orange "#ffb86c"
            cyan "#8be9fd"
            black "#000000"
            white "#f8f8f2"
        }
    }
  '';

  # Zellij layout
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
            children
        }
    }
  '';

  # Shell aliases for zellij
  home.shellAliases = {
    z = "zellij";
    za = "zellij attach";
    zl = "zellij list-sessions";
    zk = "zellij kill-session";
    zr = "zellij run";
    zcl = "zellij clear";
    zd = "zellij detach";
  };

  # Environment variables
  home.sessionVariables = {
    ZELLIJ_CONFIG_DIR = "${config.xdg.configHome}/zellij";
  };
}
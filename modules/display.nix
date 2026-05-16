{ config, pkgs, lib, ... }:

{
  # Ly - TUI Display Manager
  # Note: Ly needs system-level configuration

  home.packages = with pkgs; [
    ly
  ];

  # Ly configuration reference
  xdg.configFile."ly/config.ini.example".text = ''
    # Ly display manager configuration
    animation = "matrix"
    bg = 1e1e2e
    fg = cdd6f4
    input_bg = 313244
    accent = cba6f7
    char = *
    margin_top = 2
    margin_bottom = 2
    clear_password = true
    show_hostname = true
  '';
}
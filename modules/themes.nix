{ config, pkgs, lib, isLinux, ... }:

{
  # Theme-related packages - minimal set (Linux only due to GTK dependencies)
  home.packages = lib.optionals isLinux (with pkgs; [
    # GTK themes (Linux) - Dracula
    dracula-theme

    # GTK engines
    gtk-engine-murrine

    # Icon themes (Linux)
    papirus-icon-theme

    # Cursor themes (Linux)
    bibata-cursors
  ]);

  # GTK configuration (Linux only) - Dracula theme
  gtk = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    font = {
      name = "JetBrains Mono NF 11";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  # Qt configuration (Linux only)
  qt = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  # FZF configuration
  home.sessionVariables = {
    FZF_DEFAULT_OPTS = "--color=bg:#282a36,bg+:#44475a,spinner:#bd93f9,hl:#ff79c6 " +
                       "--color=fg:#f8f8f2,header:#ff79c6,info:#bd93f9,pointer:#bd93f9 " +
                       "--color=marker:#50fa7b,fg+:#f8f8f2,prompt:#bd93f9,hl+:#ff79c6";
  };
}
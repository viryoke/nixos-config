{ config, pkgs, lib, isLinux, ... }:

lib.mkIf isLinux {
  # Fcitx5 - Input Method Framework for Chinese input (Linux only)

  home.packages = [
    # Fcitx5 core
    pkgs.fcitx5
    pkgs.fcitx5-gtk

    # Qt support
    pkgs.libsForQt5.fcitx5-qt

    # Chinese input (from qt6Packages)
    pkgs.qt6Packages.fcitx5-chinese-addons

    # Configuration tool
    pkgs.qt6Packages.fcitx5-configtool
  ];

  # Fcitx5 environment variables
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };

  # Fcitx5 configuration
  xdg.configFile."fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Layout=us

    [Groups/0/Items/0]
    Name=keyboard-us

    [Groups/0/Items/1]
    Name=pinyin

    [Hotkey]
    EnumerateGroupForwardKeys=Control+Alt+Space
  '';

  # Autostart fcitx5
  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "Fcitx5 Input Method Daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.fcitx5}/bin/fcitx5 -d";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
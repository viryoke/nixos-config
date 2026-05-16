{ config, pkgs, lib, ... }:

{
  # Fcitx5 - Input Method Framework for Chinese input

  home.packages = with pkgs; [
    # Fcitx5 core
    fcitx5
    fcitx5-gtk
    fcitx5-qt

    # Chinese input
    fcitx5-chinese-addons

    # Configuration tool
    fcitx5-configtool
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
  systemd.user.services = lib.mkIf pkgs.stdenv.isLinux {
    fcitx5 = {
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
  };
}
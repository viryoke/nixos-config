{ config, pkgs, lib, ... }:

{
  # Clash Verge Rev - GUI proxy client (available in nixpkgs unstable)
  home.packages = with pkgs; [
    clash-verge-rev
  ];

  # Proxy aliases
  home.shellAliases = {
    proxy-on = "export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890";
    proxy-off = "unset http_proxy https_proxy all_proxy";
    proxy-test = "curl -I https://www.google.com";
    myip = "curl -s ifconfig.me";
  };

  # Environment variables
  home.sessionVariables = {
    NO_PROXY = "localhost,127.0.0.1,::1,*.local";
  };

  # Clash Verge Rev configuration directory
  xdg.configFile."clash-verge/.keep".text = "";

  # Autostart clash-verge-rev on Linux
  systemd.user.services = lib.mkIf pkgs.stdenv.isLinux {
    clash-verge-rev = {
      Unit = {
        Description = "Clash Verge Rev Proxy Client";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge-rev";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
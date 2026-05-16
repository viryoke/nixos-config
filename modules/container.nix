{ config, pkgs, lib, ... }:

{
  # Podman - Rootless container runtime (Linux only)
  home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    # Podman - Docker alternative (rootless, daemonless)
    podman
    podman-compose

    # Container analysis
    dive

    # Podman TUI
    podman-tui
  ]);

  # Podman configuration (Linux only)
  xdg.configFile = lib.mkIf pkgs.stdenv.isLinux {
    "containers/containers.conf".text = builtins.toJSON {
      containers = {
        default_capabilities = [
          "CHOWN"
          "DAC_OVERRIDE"
          "FOWNER"
          "FSETID"
          "KILL"
          "NET_BIND_SERVICE"
          "SETFCAP"
          "SETGID"
          "SETPCAP"
          "SETUID"
        ];
        log_driver = "journald";
      };
      engine = {
        network_backend = "cni";
      };
    };
  };

  # Docker-compatible aliases (Linux only)
  home.shellAliases = lib.mkIf pkgs.stdenv.isLinux {
    docker = "podman";
    docker-compose = "podman-compose";
    d = "podman";
    dc = "podman-compose";
    dps = "podman ps";
    dpsa = "podman ps -a";
    di = "podman images";
    dex = "podman exec -it";
    dstop = "podman stop";
    dlog = "podman logs";
    dprune = "podman system prune -a --volumes";
    dcup = "podman-compose up -d";
    dcdown = "podman-compose down";
    dcps = "podman-compose ps";
    dclogs = "podman-compose logs";
    pt = "podman-tui";
  };
}
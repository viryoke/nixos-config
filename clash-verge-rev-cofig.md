  # Install clash-verge-rev
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    serviceMode = true;
    autoStart = true;
  };
  networking.firewall = {
    trustedInterfaces = [ "Mihomo" ];
    checkReversePath = "loose";
  };

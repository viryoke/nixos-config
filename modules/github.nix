{ config, pkgs, lib, ... }:

{
  # GitHub CLI (gh)
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
    editor = "nvim";
    prompt = "enabled";
    pager = "bat";

    settings = {
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pc = "pr create";
        pm = "pr merge";
        pcl = "pr close";
        pl = "pr list";
        il = "issue list";
        iv = "issue view";
        ic = "issue create";
      };
    };
  };

  # Additional GitHub-related packages
  home.packages = with pkgs; [
    gh-emoji
    act
    actionlint
  ];

  # Shell aliases for gh
  home.shellAliases = {
    ghc = "gh repo create";
    ghr = "gh repo view";
    ghf = "gh repo fork";
    ghcl = "gh repo clone";
    prc = "gh pr create";
    prv = "gh pr view";
    prm = "gh pr merge";
    isc = "gh issue create";
    isv = "gh issue view";
  };
}
{ config, pkgs, lib, ... }:

{
  # Bun - Fast JavaScript runtime and package manager

  # Bun environment configuration
  home.sessionVariables = {
    BUN_INSTALL = "${config.xdg.dataHome}/bun";
    BUN_CACHE_DIR = "${config.xdg.cacheHome}/bun";
  };

  # Bun shell aliases
  home.shellAliases = {
    bi = "bun install";
    ba = "bun add";
    br = "bun remove";
    bu = "bun update";
    bx = "bun x";
    bs = "bun run start";
    bt = "bun test";
    bdev = "bun run dev";
    bbuild = "bun run build";
  };

  # Create directory structure for bun
  home.file = {
    "${config.xdg.dataHome}/bun/.keep".text = "";
    "${config.xdg.cacheHome}/bun/.keep".text = "";
  };

  # JavaScript/Node.js runtime and package manager
  # bun: Fast JS runtime and package manager (alternative to npm/yarn)
  # nodejs_22: Node.js runtime for tools requiring npm/node (e.g., claude-code)
  home.packages = with pkgs; [
    bun
    nodejs_22
  ];
}
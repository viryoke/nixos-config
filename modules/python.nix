{ config, pkgs, lib, ... }:

{
  # uv - Fast Python package manager

  # Python environment configuration
  home.sessionVariables = {
    UV_HOME = "${config.xdg.dataHome}/uv";
    UV_CACHE_DIR = "${config.xdg.cacheHome}/uv";
  };

  # uv shell aliases
  home.shellAliases = {
    pi = "uv pip install";
    pu = "uv pip uninstall";
    pf = "uv pip freeze";
    pl = "uv pip list";
    pv = "uv venv";
    ua = "uv add";
    ur = "uv remove";
    us = "uv sync";
    ul = "uv lock";
    urun = "uv run";
    uinit = "uv init";
  };

  # Create directory structure for uv
  home.file = {
    "${config.xdg.dataHome}/uv/.keep".text = "";
    "${config.xdg.cacheHome}/uv/.keep".text = "";
  };

  # Minimal Python tools - only uv and python3
  # All other Python packages/linters/formatters are installed in project venvs
  home.packages = with pkgs; [
    uv
    python3
  ];
}
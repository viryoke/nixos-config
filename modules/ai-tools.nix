{ config, pkgs, lib, ... }:

{
  # Claude Code CLI
  # Note: nodejs_22 is installed via nodejs.nix (required for claude-code)

  home.packages = [ ];

  # Claude Code installation script (using bun from nodejs.nix)
  home.file.".local/bin/install-claude-code".text = ''
    #!/usr/bin/env bash
    set -e

    echo "Installing Claude Code CLI..."

    # Install using bun (faster than npm)
    bun install -g @anthropic-ai/claude-code

    echo "Claude Code installed successfully!"
    echo "Run 'claude' to start."
  '';

  # Claude Code configuration
  xdg.configFile."claude-code/config.json".text = builtins.toJSON {
    editor = "nvim";
    pager = "bat";
    model = "claude-opus-4-7";
    temperature = 0.7;
    auto_approve_safe = true;
    ask_for_permission = "suggest_edits";
    output_format = "stream-json";
    max_tokens = 4096;
    context_window = 200000;
    project_detection = true;
    respect_gitignore = true;
    follow_symlinks = false;
    sandbox = true;
    allow_network = false;
    log_level = "info";
    log_file = "${config.xdg.stateHome}/claude-code.log";
  };

  # Claude Code aliases
  home.shellAliases = {
    claude = "claude-code";
    cc = "claude-code";
    cchat = "claude-code chat";
    cedit = "claude-code edit";
    cdiff = "claude-code diff";
    ccommit = "claude-code commit";
  };

  # Environment variables for Claude Code
  home.sessionVariables = {
    ANTHROPIC_API_KEY_FILE = "${config.xdg.configHome}/claude-code/api-key";
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude-code";
    CLAUDE_DATA_DIR = "${config.xdg.dataHome}/claude-code";
    CLAUDE_CACHE_DIR = "${config.xdg.cacheHome}/claude-code";
  };

  # Create necessary directories
  home.file = {
    "${config.xdg.configHome}/claude-code/.keep".text = "";
    "${config.xdg.dataHome}/claude-code/.keep".text = "";
    "${config.xdg.cacheHome}/claude-code/.keep".text = "";
    "${config.xdg.stateHome}/claude-code/.keep".text = "";
  };

  # Gitignore for Claude Code
  xdg.configFile."claude-code/ignore".text = ''
    # Secrets
    .env
    .env.local
    *.pem
    *.key
    api-key
    credentials.json

    # Large files
    *.mp4
    *.mov
    *.avi
    *.mkv
    *.pdf
    *.docx
    *.xlsx
    *.pptx
    *.zip
    *.tar.gz

    # Build outputs
    dist/
    build/
    out/
    target/

    # Dependencies
    node_modules/
    vendor/
    .venv/
    venv/

    # Logs
    *.log
    logs/

    # Temporary
    tmp/
    .tmp/
    *.tmp

    # Cache
    .cache/
    cache/
  '';
}
{ config, pkgs, lib, ... }:

{
  # Visual Studio Code
  home.packages = with pkgs; [
    # VSCode
    vscode

    # VSCode extensions manager
    vscode-extensions-update

    # Alternative: VSCodium (open source build without telemetry)
    # vscodium
  ];

  # VSCode configuration (has built-in Dracula theme extension)
  xdg.configFile."Code/User/settings.json".text = builtins.toJSON {
    # Editor settings
    "editor.fontFamily" = "'JetBrains Mono NF', 'JetBrains Mono', monospace";
    "editor.fontSize" = 14;
    "editor.fontLigatures" = true;
    "editor.lineHeight" = 22;
    "editor.tabSize" = 2;
    "editor.insertSpaces" = true;
    "editor.detectIndentation" = true;
    "editor.formatOnSave" = true;
    "editor.formatOnPaste" = true;
    "editor.minimap.enabled" = false;
    "editor.renderWhitespace" = "selection";
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.smoothScrolling" = true;
    "editor.bracketPairColorization.enabled" = true;
    "editor.guides.bracketPairs" = true;
    "editor.guides.indentation" = true;
    "editor.linkedEditing" = true;
    "editor.wordWrap" = "off";
    "editor.rulers" = [ 100 ];

    # Terminal settings
    "terminal.integrated.fontFamily" = "'JetBrains Mono NF'";
    "terminal.integrated.fontSize" = 14;
    "terminal.integrated.lineHeight" = 1.2;
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.cursorStyle" = "block";
    "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
    "terminal.integrated.shell.osx" = "${pkgs.zsh}/bin/zsh";
    "terminal.integrated.defaultProfile.linux" = "zsh";
    "terminal.integrated.defaultProfile.osx" = "zsh";

    # Workbench settings - Use Dracula theme extension
    "workbench.colorTheme" = "Dracula";  # Built-in theme from extension
    "workbench.iconTheme" = "vscode-icons";
    "workbench.productIconTheme" = "fluent-icons";
    "workbench.startupEditor" = "none";
    "workbench.editor.showTabs" = "multiple";
    "workbench.editor.enablePreview" = false;
    "workbench.list.smoothScrolling" = true;
    "workbench.sideBar.location" = "left";
    "workbench.activityBar.location" = "side";
    "workbench.statusBar.visible" = true;
    "workbench.editor.wrapTabs" = true;

    # Window settings (transparency and blur for Wayland/X11)
    "window.titleBarStyle" = "custom";
    "window.customTitleBarVisibility" = "auto";
    "window.autoDetectHighContrast" = false;
    "window.nativeTabs" = true;  # macOS
    "window.nativeFullScreen" = true;  # macOS

    # File settings
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
    "files.trimTrailingWhitespace" = true;
    "files.trimFinalNewlines" = true;
    "files.insertFinalNewline" = true;
    "files.exclude" = {
      "**/.git" = true;
      "**/.svn" = true;
      "**/.hg" = true;
      "**/CVS" = true;
      "**/.DS_Store" = true;
      "**/Thumbs.db" = true;
      "**/.direnv" = true;
      "**/.envrc" = true;
      "**/node_modules" = true;
      "**/__pycache__" = true;
      "**/.venv" = true;
      "**/venv" = true;
      "**/result" = true;
      "**/result-*" = true;
    };

    # Search settings
    "search.exclude" = {
      "**/node_modules" = true;
      "**/bower_components" = true;
      "**/*.code-search" = true;
      "**/.direnv" = true;
      "**/.envrc" = true;
      "**/result" = true;
      "**/result-*" = true;
    };

    # Git settings
    "git.enabled" = true;
    "git.autofetch" = true;
    "git.autorefresh" = true;
    "git.confirmSync" = false;
    "git.enableSmartCommit" = true;
    "git.openRepositoryInParentFolders" = "always";

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    # Extensions
    "extensions.autoUpdate" = true;
    "extensions.autoCheckUpdates" = true;
    "extensions.ignoreRecommendations" = false;
    "extensions.showRecommendationsOnlyOnDemand" = true;

    # Language-specific settings
    "[nix]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "nix-community.nixfmt-vscode";
      "editor.tabSize" = 2;
    };
    "[python]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "charliermarsh.ruff";
      "editor.tabSize" = 4;
    };
    "[javascript]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };
    "[typescript]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };
    "[json]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };
    "[yaml]" = {
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
    };
    "[rust]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
    };
    "[go]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "golang.go";
    };
    "[lua]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "sumneko.lua";
    };

    # Remote settings
    "remote.SSH.remoteServerHash" = "none";

    # Debug settings
    "debug.console.fontSize" = 14;
    "debug.console.fontFamily" = "'JetBrains Mono NF'";

    # Notebook settings
    "notebook.cellToolbarLocation" = {
      "default" = "right";
      "jupyter-notebook" = "left";
    };

    # Output settings
    "output.fontSize" = 14;
    "output.fontFamily" = "'JetBrains Mono NF'";

    # Problems settings
    "problems.sortOrder" = "position";

    # Hover settings
    "hover.sticky" = true;
  };

  # VSCode keybindings
  xdg.configFile."Code/User/keybindings.json".text = builtins.toJSON [
    # Custom keybindings
    {
      key = "ctrl+shift+p";
      command = "workbench.action.showCommands";
    }
    {
      key = "ctrl+p";
      command = "workbench.action.quickOpen";
    }
    {
      key = "ctrl+shift+f";
      command = "workbench.action.findInFiles";
    }
    {
      key = "ctrl+shift+n";
      command = "workbench.action.newWindow";
    }
    {
      key = "ctrl+w";
      command = "workbench.action.closeWindow";
      when = "editorTabsFocus";
    }
    {
      key = "ctrl+k ctrl+w";
      command = "workbench.action.closeAllEditors";
    }
    {
      key = "ctrl+tab";
      command = "workbench.action.quickOpenPreviousRecentlyUsedEditor";
    }
    {
      key = "ctrl+shift+tab";
      command = "workbench.action.quickOpenLeastRecentlyUsedEditor";
    }
    {
      key = "ctrl+`";
      command = "workbench.action.terminal.toggleTerminal";
    }
    {
      key = "ctrl+shift+`";
      command = "workbench.action.terminal.new";
    }
    {
      key = "ctrl+1";
      command = "workbench.action.openEditorAtIndex1";
    }
    {
      key = "ctrl+2";
      command = "workbench.action.openEditorAtIndex2";
    }
    {
      key = "ctrl+3";
      command = "workbench.action.openEditorAtIndex3";
    }
    {
      key = "ctrl+b";
      command = "workbench.action.toggleSidebarVisibility";
    }
    {
      key = "ctrl+shift+b";
      command = "workbench.action.toggleActivityBarVisibility";
    }
    {
      key = "alt+1";
      command = "workbench.view.explorer";
    }
    {
      key = "alt+2";
      command = "workbench.view.search";
    }
    {
      key = "alt+3";
      command = "workbench.view.scm";
    }
    {
      key = "alt+4";
      command = "workbench.view.debug";
    }
    {
      key = "alt+5";
      command = "workbench.view.extensions";
    }
    # Editor keybindings
    {
      key = "ctrl+d";
      command = "editor.action.copyLinesDownAction";
      when = "editorTextFocus";
    }
    {
      key = "ctrl+shift+d";
      command = "editor.action.copyLinesUpAction";
      when = "editorTextFocus";
    }
    {
      key = "alt+down";
      command = "editor.action.moveLinesDownAction";
      when = "editorTextFocus";
    }
    {
      key = "alt+up";
      command = "editor.action.moveLinesUpAction";
      when = "editorTextFocus";
    }
    {
      key = "ctrl+shift+k";
      command = "editor.action.deleteLines";
      when = "editorTextFocus";
    }
    {
      key = "ctrl+/";
      command = "editor.action.commentLine";
      when = "editorTextFocus";
    }
    {
      key = "ctrl+shift+/";
      command = "editor.action.blockComment";
      when = "editorTextFocus";
    }
  ];

  # VSCode aliases
  home.shellAliases = {
    code = "code";
    vscode = "code";
    vscodium = "codium";  # if using vscodium
  };

  # Note: VSCode transparency requires system-level settings
  # For Wayland, you can set:
  # - GTK_THEME=Adwaita-dark
  # - Use compositor blur (niri, hyprland support this)
  home.file.".local/share/vscode-transparency-info.md".text = ''
    # VSCode Transparency and Blur

    ## Wayland (Niri/Hyprland)

    VSCode transparency is handled by the compositor:

    ### Niri
    Add window rule in niri config:
    ```kdl
    window-rules [
      {
        match app-id="^(code|Code|vscode|VSCodium)$"
        opacity 0.9
      }
    ]
    ```

    ### Hyprland
    ```conf
    windowrulev2 = opacity 0.9 0.9, class:^(code|Code)$
    windowrulev2 = blur, class:^(code|Code)$
    ```

    ## X11

    Use picom compositor:
    ```conf
    opacity-rule = [ "90:class_g = 'Code'" ]
    blur-background = true
    ```

    ## macOS

    Install via Homebrew and use system transparency:
    ```bash
    brew install --cask visual-studio-code
    ```
  '';

  # VSCode extensions (manual installation guide)
  home.file.".local/share/vscode-extensions.md".text = ''
    # Recommended VSCode Extensions

    Install using: `code --install-extension <extension-id>`

    ## Essential
    - dracula-theme.theme-dracula    # Dracula theme
    - vscode-icons-team.vscode-icons # File icons
    - aaron-bond.better-comments     # Better comments

    ## Editor
    - vscodevim.vim                  # Vim keybindings (optional)
    - editorconfig.editorconfig      # EditorConfig support
    - streetsidesoftware.code-spell-checker # Spell checker

    ## Git
    - eamodio.gitlens                # Git supercharged
    - github.vscode-pull-request-github # GitHub PR

    ## Languages

    ### Nix
    - nix-community.nixfmt-vscode    # Nix formatter
    - jnoortheen.nix-ide             # Nix IDE support

    ### Python
    - charliermarsh.ruff             # Ruff linter/formatter
    - ms-python.python               # Python support
    - ms-python.debugpy              # Python debugger

    ### JavaScript/TypeScript
    - esbenp.prettier-vscode         # Prettier formatter
    - dbaeumer.vscode-eslint         # ESLint

    ### Rust
    - rust-lang.rust-analyzer        # Rust analyzer

    ### Go
    - golang.go                      # Go support

    ### Lua
    - sumneko.lua                    # Lua language server

    ### Shell
    - timonwong.shellcheck           # ShellCheck
    - foxundermoon.vs-shell-format   # Shell formatter

    ## Tools
    - teksw.rainbow-brackets         # Rainbow brackets
    - shardulm94.trailing-spaces     # Show trailing spaces
    - wayou.vscode-todo-highlight    # TODO highlight
    - usernamehw.errorlens           # Inline errors
    - waditw.json                    # JSON tools

    ## AI (Optional)
    - github.copilot                 # GitHub Copilot
    - continue.continue              # Continue AI assistant

    ## Remote
    - ms-vscode-remote.remote-ssh    # SSH remote
    - ms-vscode-remote.remote-containers # Docker containers

    ## Install all recommended:
    ```bash
    code --install-extension dracula-theme.theme-dracula
    code --install-extension vscode-icons-team.vscode-icons
    code --install-extension eamodio.gitlens
    code --install-extension nix-community.nixfmt-vscode
    code --install-extension jnoortheen.nix-ide
    code --install-extension charliermarsh.ruff
    code --install-extension ms-python.python
    code --install-extension esbenp.prettier-vscode
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension rust-lang.rust-analyzer
    code --install-extension golang.go
    code --install-extension sumneko.lua
    code --install-extension timonwong.shellcheck
    ```
  '';
}
{ config, pkgs, lib, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    userName = "viryoke";
    userEmail = "viryoke@users.noreply.github.com";

    # Git aliases
    aliases = {
      co = "checkout";
      br = "branch";
      st = "status";
      lg = "log --oneline --graph --all";
      cm = "commit -m";
      am = "commit --amend --no-edit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      branches = "branch -a";
      tags = "tag -n1";
      stashes = "stash list";
      stats = "diff --stat";
      discard = "checkout --";
      uncommit = "reset --soft HEAD^";
      filelog = "log -u";
      diffc = "diff --cached";
      track = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)";
    };

    # Extra configuration
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      core.pager = "delta";
      core.excludesfile = "${config.xdg.configHome}/git/ignore";
      core.attributesfile = "${config.xdg.configHome}/git/attributes";
      pull.rebase = false;
      push.autoSetupRemote = true;
      push.followTags = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      rebase.autoStash = true;
      rebase.autosquash = true;
      merge.conflictstyle = "zdiff3";
      merge.tool = "meld";
      mergetool.meld.cmd = "meld \"$LOCAL\" \"$MERGED\" \"$REMOTE\"";
      mergetool.meld.trustExitCode = false;
      diff.tool = "meld";
      difftool.meld.cmd = "meld \"$LOCAL\" \"$REMOTE\"";
      difftool.prompt = false;
      credential.helper = "store --file=${config.xdg.dataHome}/git/credentials";
      rerere.enabled = true;
      log.date = "iso";
      column.ui = "auto";
      color.ui = "auto";
      transfer.fsckobjects = true;
      receive.fsckobjects = true;
      dispatch.autoSetupMerge = true;
      advice.detachedHead = false;
      advice.pushNonFastForward = false;
      status.showUntrackedFiles = "all";
      status.short = true;
      status.branch = true;
      tag.sort = "version:refname";
      branch.sort = "-committerdate";
      include.path = "${config.xdg.configHome}/git/config.local";
    };

    # Delta integration (better diff viewer)
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        hyperlinks = true;
        hyperlinks-commit-link-style = "commit.hash";
        syntax-theme = "Catppuccin Mocha";
        theme = "Catppuccin Mocha";
        file-style = "omit";
        hunk-header-style = "line-number code";
        minus-style = "syntax #f38ba8";
        plus-style = "syntax #a6e3a1";
        minus-emph-style = "syntax #f38ba8";
        plus-emph-style = "syntax #a6e3a1";
        minus-non-emph-style = "syntax #313244";
        plus-non-emph-style = "syntax #313244";
        blame-format = "{timestamp} {author}";
        blame-code-style = "syntax";
        blame-separator-format = "| ";
        blame-separator-style = "#6c7086";
        blame-padding-format = " {commit:";
        max-line-distance = 0.6;
        true-color = "always";
      };
    };

    # Hooks
    hooks = {
      pre-commit = pkgs.writeShellScript "pre-commit" ''
        # Check for large files
        large_files=$(git diff --cached --name-only | xargs -I {} sh -c 'test $(wc -c < {}) -gt 500000 && echo {}')
        if [ -n "$large_files" ]; then
          echo "Warning: Large files detected:"
          echo "$large_files"
          echo "Consider using git-lfs for large files"
        fi
      '';
    };
  };

  # Git ignore patterns
  xdg.configFile."git/ignore".text = ''
    # OS generated files
    .DS_Store
    .DS_Store?
    ._*
    .Spotlight-V100
    .Trashes
    ehthumbs.db
    Thumbs.db
    desktop.ini

    # Editor directories and files
    .vscode/
    .idea/
    *.swp
    *.swo
    *~
    .nvim/
    .helix/

    # Environment files
    .env
    .env.local
    .env.*.local
    *.pem
    *.key

    # Build outputs
    dist/
    build/
    out/
    target/
    *.o
    *.class
    *.jar
    *.war

    # Dependencies
    node_modules/
    vendor/
    .venv/
    venv/
    __pycache__/
    *.pyc
    .pyo

    # Logs
    logs/
    *.log
    npm-debug.log*
    yarn-debug.log*
    yarn-error.log*

    # Testing
    coverage/
    .nyc_output/
    test-results/

    # Temporary files
    tmp/
    temp/
    .tmp/
    .temp/
    *.tmp
    *.temp
    *.bak
    *.backup

    # Nix
    result
    result-*
    .direnv/
    .envrc

    # Archives
    *.zip
    *.tar
    *.tar.gz
    *.tar.bz2
    *.tgz
    *.rar
    *.7z

    # Compiled files
    *.exe
    *.dll
    *.so
    *.dylib
  '';

  # Git attributes
  xdg.configFile."git/attributes".text = ''
    # Auto detect text files and perform LF normalization
    * text=auto

    # Force LF for specific files
    *.nix text eol=lf
    *.sh text eol=lf
    *.bash text eol=lf
    *.zsh text eol=lf
    *.nu text eol=lf
    *.py text eol=lf
    *.js text eol=lf
    *.ts text eol=lf
    *.json text eol=lf
    *.yaml text eol=lf
    *.yml text eol=lf
    *.toml text eol=lf
    *.md text eol=lf
    *.txt text eol=lf
    *.cfg text eol=lf
    *.conf text eol=lf
    *.ini text eol=lf

    # Exclude from export
    .gitignore export-ignore
    .gitattributes export-ignore
    .github/ export-ignore
    .direnv/ export-ignore
    .envrc export-ignore
    flake.nix export-ignore
    flake.lock export-ignore
  '';

  # Lazygit configuration
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = 3;
        showRandomTip = false;
        showFileTree = true;
        showCommandLog = true;
        showBottomLine = true;
        border = "single";
        animateExplosion = true;
        theme = {
          activeBorderColor = [ "#cba6f7" "bold" ];
          inactiveBorderColor = [ "#6c7086" ];
          searchingActiveBorderColor = [ "#f5a97f" "bold" ];
          optionsTextColor = [ "#89dceb" ];
          selectedLineBgColor = [ "#313244" ];
          selectedRangeBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#45475a" ];
          cherryPickedCommitFgColor = "#f5c2e7";
          unstagedChangesColor = "#f38ba8";
          defaultFgColor = "#cdd6f4";
        };
        authorColors = {
          "*" = "#b4befe";
          "viryoke" = "#cba6f7";
        };
      };
      git = {
        paging = {
          pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-commit-link-style=commit.hash";
        };
        commit = {
          signOff = false;
        };
        merging = {
          manualCommit = false;
          args = "--no-ff";
        };
        rebase = {
          args = "--autosquash";
        };
      };
      refresher = {
        refreshInterval = 10;
        fetchInterval = 60;
      };
      update = {
        method = "never";
      };
      reporter = "less";
      confirmOnQuit = false;
      quitOnTopLevelReturn = true;
    };
  };

  # Git credentials storage (XDG compliant)
  home.file."${config.xdg.dataHome}/git/.keep".text = "";
}
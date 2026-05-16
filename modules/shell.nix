{ config, pkgs, lib, ... }:

{
  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      lt = "eza -la --icons --group-directories-first --tree --level=2";
      cat = "bat --paging=never";
      find = "fd";
      grep = "rg";
      du = "dust";
      # cd alias handled by zoxide --cmd cd in cli-tools.nix
      nv = "nvim";
      hx = "helix";
      fm = "yazi";

      # Git aliases
      g = "git";
      ga = "git add";
      gc = "git commit";
      gs = "git status";
      gp = "git push";
      gl = "git log --oneline --graph";

      # System aliases
      rebuild = "home-manager switch --flake";
      update = "nix flake update";
    };

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      # Note: zoxide is configured in cli-tools.nix with programs.zoxide
      # which automatically handles shell integration
      # Key bindings
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
      bindkey '^R' history-incremental-search-backward

      # Enable fzf if available
      if command -v fzf &> /dev/null; then
        eval "$(fzf --zsh)"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "history" "extract" ];
      theme = "robbyrussell";
    };

    # Use p10k if powerlevel10k is preferred
    # zplug = {
    #   enable = true;
    #   plugins = [
    #     { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
    #   ];
    # };
  };

  # Nushell configuration
  programs.nushell = {
    enable = true;

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      cat = "bat --paging=never";
      find = "fd";
      grep = "rg";
      du = "dust";
      nv = "nvim";
      hx = "helix";
      fm = "yazi";
    };

    extraConfig = ''
      $env.config = {
        show_banner: false,
        completions: {
          algorithm: "fuzzy",
          case_sensitive: false,
        },
        history: {
          file_format: "sqlite",
          max_size: 10000,
          sync_on_enter: true,
        },
        keybindings: [
          {
            name: fzf_menu
            modifier: control
            keycode: char_f
            mode: emacs
            action: {
              type: execute
              command: "fzf | decode utf-8 | split row ' ' | first"
            }
          }
        ]
      }

      # Note: zoxide integration handled by cli-tools.nix programs.zoxide
      # with enableNushellIntegration = true
    '';

    extraEnv = ''
      $env.EDITOR = "nvim"
      $env.VISUAL = "nvim"
    '';
  };

  # Additional shell tools
  # Note: zoxide is installed via cli-tools.nix programs.zoxide
  home.packages = with pkgs; [
    zsh         # Default shell
    fzf
    direnv
    nix-direnv
    starship    # Alternative prompt, works for both zsh and nushell
  ];

  # Direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "1m";
      };
    };
  };

  # Set zsh as preferred shell (SHELL environment variable)
  # Note: For Ubuntu/Arch, you need to manually change login shell with:
  #   chsh -s $(which zsh)
  # For Mac (nix-darwin) and NixOS, the shell is already set in system config
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # Starship prompt configuration (optional, works with both shells)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold blue";
      };
      git_branch = {
        symbol = "";
        style = "bold purple";
      };
      nix_shell = {
        symbol = " ";
        style = "bold blue";
      };
      package = {
        disabled = true;
      };
      cmd_duration = {
        min_time = 500;
        format = "took [$duration](bold yellow)";
      };
    };
  };
}
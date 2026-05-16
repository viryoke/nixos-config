{ config, pkgs, lib, inputs, ... }:

{
  # Neovim with LazyVim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;  # New default
    withPython3 = false;  # New default

    package = pkgs.neovim;

    # LazyVim bootstrap configuration
    initLua = ''
      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      -- Load LazyVim
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.extras.lang.python" },
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "lazyvim.plugins.extras.lang.yaml" },
          { import = "lazyvim.plugins.extras.lang.toml" },
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.lang.nix" },
          { import = "lazyvim.plugins.extras.lang.markdown" },

          -- Dracula theme
          {
            "dracula/vim",
            name = "dracula",
            lazy = false,
            priority = 1000,
          },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        install = { missing = true },
        checker = { enabled = true },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })

      -- Basic settings
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      vim.cmd.colorscheme("dracula")
      vim.opt.guifont = "JetBrains Mono NF:h14"
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.splitright = true
      vim.opt.splitbelow = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.undofile = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.wrap = false
      vim.opt.scrolloff = 8
      vim.opt.cursorline = true
      vim.opt.mouse = "a"
      vim.opt.pumblend = 10
      vim.opt.winblend = 10
    '';
  };

  # Helix editor configuration
  programs.helix = {
    enable = true;
    defaultEditor = false;

    settings = {
      editor = {
        line-number = "relative";
        mouse = true;
        cursorline = true;
        auto-pairs = true;
        auto-save = true;
        soft-wrap.enable = false;
        file-picker.hidden = false;
        statusline = {
          left = [ "mode" "file-name" ];
          right = [ "diagnostics" "position" ];
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        indent-guides.render = true;
      };

      keys = {
        normal = {
          "C-f" = "file_picker";
          "C-s" = ":w";
          "C-q" = ":q";
          space.f = "file_picker";
          space.w = ":w";
          space.q = ":q";
        };
      };
    };

    themes = {
      dracula = {
        inherits = "dracula";
        "ui.background" = { bg = "none"; };
      };
    };
  };

  # Essential editor-related packages
  # Tree-sitter for Neovim parsing
  # Note: ripgrep, fd are in cli-tools.nix; lazygit in version-control.nix
  home.packages = with pkgs; [
    tree-sitter
  ];
}
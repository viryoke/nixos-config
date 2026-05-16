{ config, pkgs, lib, ... }:

{
  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;

    settings = {
      manager = {
        ratio = [ 1 3 4 ];
        sort_by = "alphabetical";
        sort_dir_first = true;
        show_hidden = false;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        image_quality = 75;
      };
      opener = {
        edit = [{ run = "$EDITOR {0}"; block = true; }];
        open = [{ run = "xdg-open {0}"; }];
      };
      keymap = {
        manager = {
          prepend_keymap = [
            { on = [ "<Enter>" ]; run = "open"; }
            { on = [ "y" ]; run = "yank"; }
            { on = [ "x" ]; run = "yank --cut"; }
            { on = [ "p" ]; run = "paste"; }
            { on = [ "d" ]; run = "remove"; }
            { on = [ "r" ]; run = "rename"; }
            { on = [ "." ]; run = "hidden toggle"; }
            { on = [ "/" ]; run = "find"; }
            { on = [ "q" ]; run = "quit"; }
            { on = [ "<C-n>" ]; run = "create"; }
          ];
        };
      };
      theme = {
        manager.cwd.fg = "#89b4fa";
        manager.hovered.bg = "#313244";
      };
    };

    keymaps = {
      manager = [
        { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to home"; }
        { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to config"; }
        { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to downloads"; }
      ];
    };
  };

  # Essential file management tools
  # Note: p7zip, rsync, trash-cli are in cli-tools.nix
  home.packages = with pkgs; [
    # Archive management
    unzip
    zip
  ];

  # Trash-cli alias (trash-cli installed via cli-tools.nix)
  home.shellAliases = {
    rm = "trash-put";
    rl = "trash-list";
    ur = "trash-restore";
    te = "trash-empty";
  };
}
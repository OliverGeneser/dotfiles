{pkgs, ...}: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>";
        key = "<leader>fa";
        options = {
          desc = "Find all files";
        };
        mode = [
          "n"
        ];
      }
    ];

    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;

      keymaps = {
        "<leader>pf" = {
          action = "find_files";
          options = {
            desc = "Find file in project";
          };
        };
        "<C-p>" = {
          action = "git_files";
          options = {
            desc = "Find file in git project";
          };
        };
        "<leader>ps" = {
          action = "live_grep";
          options = {
            desc = "Grep";
          };
        };
        "<leader>fw" = {
          action = "grep_string";
          options = {
            desc = "Search word under cursor";
          };
        };
      };

      settings = {
        vimgrep_arguments = [
          "${pkgs.ripgrep}/bin/rg"
          "-L"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--fixed-strings"
        ];
        file_ignore_patterns = [
          "^node_modules/"
          "^.devenv/"
          "^.direnv/"
          "^.git/"
        ];
        prompt_prefix = "   ";
        selection_caret = "  ";
        entry_prefix = "  ";
        color_devicons = true;
        initial_mode = "insert";
        selection_strategy = "reset";
        sorting_strategy = "ascending";
        borderchars = [
          "─"
          "│"
          "─"
          "│"
          "╭"
          "╮"
          "╯"
          "╰"
        ];
        border = {};
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
            results_width = 0.8;
          };
          vertical = {
            mirror = false;
          };
          width = 0.87;
          height = 0.80;
          preview_cutoff = 120;
        };
        set_env.COLORTERM = "truecolor";
      };
    };
  };
}

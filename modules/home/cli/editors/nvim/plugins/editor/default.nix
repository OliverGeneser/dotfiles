{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>UndotreeToggle<cr>";
        key = "<leader>u";
        options = {
          desc = "Show undo tree";
        };
        mode = [
          "n"
        ];
      }
    ];
    plugins = {
      illuminate = {
        enable = true;
        delay = 200;
        underCursor = true;
        largeFileOverrides = {
          largeFileCutoff = 2000;
        };
      };

      nvim-colorizer = {
        enable = true;
      };

      todo-comments = {
        enable = true;
      };

      indent-blankline = {
        enable = true;
        settings = {
          whitespace = {
            highlight = ["IndentBlanklineSpaceChar" "IndentBlanklineSpaceCharBlankline"];
          };
          scope = {
            show_start = false;
            show_end = false;
          };
          exclude = {
            filetypes = [
              "help"
              "terminal"
              "lazy"
              "lspinfo"
              "TelescopePrompt"
              "TelescopeResults"
              "Alpha"
              ""
            ];
          };
        };
      };

      undotree = {
        enable = true;
      };

      refactoring = {
        enable = true;
      };

      zellij = {
        enable = true;
        settings = {
          vimTmuxNavigatorKeybinds = true;
        };
      };
    };
  };
}

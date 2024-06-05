{pkgs, ...}: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>Git<cr>";
        key = "<leader>gs";
        options = {
          desc = "Git";
        };
        mode = [
          "n"
        ];
      }
    ];

    plugins = {
      which-key.registrations = {
        "<leader>gs" = "git";
      };

      diffview = {
        enable = true;
      };

      fugitive = {
        enable = true;
      };

      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          signs = {
            add = {text = "│";};
            change = {text = "│";};
            delete = {text = "󰍵";};
            topdelete = {text = "‾";};
            changedelete = {text = "~";};
            untracked = {text = "│";};
          };
        };
      };
    };
  };
}

{
  programs.nixvim = {
    keymaps = [
      {
        action = ":m '>+1<CR>gv=gv";
        key = "J";
        options = {
          desc = "Move line down";
        };
        mode = [
          "v"
        ];
      }
      {
        action = ":m '<-2<CR>gv=gv";
        key = "K";
        options = {
          desc = "Move line up";
        };
        mode = [
          "v"
        ];
      }
      {
        action = "mzJ`z";
        key = "J";
        options = {
          desc = "Combine line into one";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<C-d>zz";
        key = "<C-d>";
        options = {
          desc = "Move half down and center";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
        options = {
          desc = "Move half up and center";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "nzzzv";
        key = "n";
        options = {
          desc = "Keep cursor in middle when searching";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "Nzzzv";
        key = "N";
        options = {
          desc = "Keep cursor in middle when searching";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "'+y";
        key = "<leader>y";
        options = {
          desc = "???";
        };
        mode = [
          "n"
          "v"
        ];
      }
      {
        action = "'+Y";
        key = "<leader>Y";
        options = {
          desc = "???";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "'_d";
        key = "<leader>d";
        options = {
          desc = "???";
        };
        mode = [
          "n"
          "v"
        ];
      }
      {
        action = "<nop>";
        key = "Q";
        options = {
          desc = "???";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "'_dP";
        key = "<leader>p";
        options = {
          desc = "Paste without updating buffer";
        };
        mode = [
          "v"
        ];
      }
      {
        action = {__raw = "vim.lsp.buf.format";};
        key = "<leader>f";
        options = {
          desc = "Format";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>cnext<CR>zz";
        key = "<C-k>";
        options = {
          desc = "??";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>cprev<CR>zz";
        key = "<C-j>";
        options = {
          desc = "??";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>lnext<CR>zz";
        key = "<leader>k";
        options = {
          desc = "??";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>lprev<CR>zz";
        key = "<leader>j";
        options = {
          desc = "??";
        };
        mode = [
          "n"
        ];
      }
      {
        action = ":%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>";
        key = "<leader>s";
        options = {
          desc = "Seach";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>!chmod +x %<CR>";
        key = "<leader>x";
        options = {
          desc = "Seach";
          silent = true;
        };
        mode = [
          "n"
        ];
      }
      {
        action = "oif err != nil {<CR>}<Esc>Oreturn err<Esc>";
        key = "<leader>ee";
        options = {
          desc = "???";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>CellularAutomaton make_it_rain<CR>";
        key = "<leader>mr";
        options = {
          desc = "Make it rain!";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "so";
        key = "<leader><leader>";
        options = {
          desc = "SO";
        };
        mode = [
          "n"
        ];
      }
    ];
  };
}

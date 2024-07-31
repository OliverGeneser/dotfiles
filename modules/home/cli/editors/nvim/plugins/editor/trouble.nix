{
  programs.nixvim = {
    plugins = {
      trouble = {
        enable = true;
      };
    };

    keymaps = [
      {
        action.__raw = ''
          function()
            if require("trouble").is_open() then
              require("trouble").next({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
        key = "[t";
        options = {
          desc = "Next quickfix item";
        };
        mode = [
          "n"
        ];
      }
      {
        action.__raw = ''
          function()
          	if require("trouble").is_open() then
          		require("trouble").previous({ skip_groups = true, jump = true })
          	else
          		local ok, err = pcall(vim.cmd.cprev)
          		if not ok then
          			vim.notify(err, vim.log.levels.ERROR)
          		end
          	end
          end
        '';
        key = "]t";
        options = {
          desc = "Previous quickfix item";
        };
        mode = [
          "n"
        ];
      }
      {
        action = "<cmd>TroubleToggle<cr>";
        key = "<leader>tt";
        options = {
          desc = "Toggle Trouble";
        };
        mode = [
          "n"
        ];
      }
    ];
  };
}

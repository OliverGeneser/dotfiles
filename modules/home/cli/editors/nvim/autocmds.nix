{
  programs.nixvim = {
    autoGroups = {
      geneser.clear = true;
      highlight_yank.clear = true;
    };

    autoCmd = [
      {
        event = ["BufWritePre"];
        group = "geneser";
        desc = "";
        command = "%s/\s\+$//e";
      }
      {
        event = ["TextYankPost"];
        group = "highlight_yank";
        desc = "Highlight yanked content";
        callback = {__raw = "function() vim.highlight.on_yank({higroup = 'IncSearch', timeout = 40,}) end";};
      }
      {
        event = ["LspAttach"];
        group = "geneser";
        callback = {
          __raw = ''
              function(e)
            local opts = { buffer = e.buf }
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            end'';
        };
      }
    ];
  };
}

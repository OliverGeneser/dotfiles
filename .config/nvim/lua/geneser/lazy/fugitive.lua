return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive" })

        local Geneser_Fugitive = vim.api.nvim_create_augroup("Geneser_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = Geneser_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, { buffer = bufnr, remap = false, desc = "Fugitive push" })

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ 'pull', '--rebase' })
                end, { buffer = bufnr, remap = false, desc = "Fugitive pull rebase" })
            end,
        })

        vim.keymap.set("n", "gf", "<cmd>diffget //2<CR>", { desc = "Fugitive target" })
        vim.keymap.set("n", "gj", "<cmd>diffget //3<CR>", { desc = "Fugitive merge" })
    end
}

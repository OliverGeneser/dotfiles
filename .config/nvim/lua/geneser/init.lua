require("geneser.set")
require("geneser.remap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "geneser.lazy",
    change_detection = { notify = false }
})

vim.cmd.colorscheme "catppuccin"

local augroup = vim.api.nvim_create_augroup
local GeneserGroup = augroup('Geneser', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = GeneserGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = GeneserGroup,
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
            setmetatable(opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, setmetatable(opts, { desc = "Hover info" }))
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
            setmetatable(opts, { desc = "Workspace symbol" }))
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
            setmetatable(opts, { desc = "Open diagnostic float" }))
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
            setmetatable(opts, { desc = "Code Action" }))
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
            setmetatable(opts, { desc = "Find all references" }))
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, setmetatable(opts, { desc = "Rename" }))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
            setmetatable(opts, { desc = "Signature help" }))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
            setmetatable(opts, { desc = "Diagnostic go to next" }))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
            setmetatable(opts, { desc = "Diagnostic go to prev" }))
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

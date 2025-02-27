require("geneser.set")
require("geneser.remap")
require("geneser.lazy_init")

vim.cmd.colorscheme("catppuccin-mocha")

local augroup = vim.api.nvim_create_augroup
local geneser_group = augroup("Geneser", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = geneser_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = geneser_group,
	callback = function(e)
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, { buffer = e.buf, desc = "LSP: [G]oto [D]efinition" })
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, { buffer = e.buf, desc = "LSP: [G]oto [R]eferences" })
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, { buffer = e.buf, desc = "LSP: hover" })
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, { buffer = e.buf, desc = "LSP: Workspace symbol" })
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, { buffer = e.buf, desc = "LSP: Open float" })
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, { buffer = e.buf, desc = "LSP: Code action" })
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, { buffer = e.buf, desc = "LSP: Rename" })
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, { buffer = e.buf, desc = "LSP: Signature help" })
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, { buffer = e.buf, desc = "LSP: Goto next" })
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, { buffer = e.buf, desc = "LSP: Goto previous" })
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

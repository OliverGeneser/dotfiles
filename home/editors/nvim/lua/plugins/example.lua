-- since this is just an example spec, don't actually load anything here and return an empty spec
if true then
	return {
		{
			"LazyVim/LazyVim",
			opts = {
				colorscheme = "catppuccin",
			},
		},
		{ import = "lazyvim.plugins.extras.lang.tailwind" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.formatting.biome" },
		{ import = "lazyvim.plugins.extras.editor.harpoon2" },
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "u" },
				},
				signs_staged = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			},
		},
		{ "folke/tokyonight.nvim", enabled = false },
		{
			"catppuccin/nvim",
			config = function()
				vim.cmd.colorscheme("catppuccin-mocha")
			end,
		},
		{
			"neovim/nvim-lspconfig",
			---@class PluginLspOpts
			opts = {
				folds = {
					enabled = false,
				},
				inlay_hints = {
					enabled = false,
				},
			},
		},
		{
			"jiaoshijie/undotree",
			dependencies = { "nvim-lua/plenary.nvim" },
			---@module 'undotree.collector'
			---@type UndoTreeCollector.Opts
			opts = {
				-- your options
			},
			keys = { -- load the plugin only when using it's keybinding:
				{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle undotree" },
			},
		},
		{
			"brenoprata10/nvim-highlight-colors",
			config = function()
				require("nvim-highlight-colors").setup({
					---Render style
					---@usage 'background'|'foreground'|'virtual'
					render = "background",

					---Set virtual symbol (requires render to be set to 'virtual')
					virtual_symbol = "■",

					---Set virtual symbol suffix (defaults to '')
					virtual_symbol_prefix = "",

					---Set virtual symbol suffix (defaults to ' ')
					virtual_symbol_suffix = " ",

					---Set virtual symbol position()
					---@usage 'inline'|'eol'|'eow'
					---inline mimics VS Code style
					---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
					---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
					virtual_symbol_position = "inline",

					---Highlight hex colors, e.g. '#FFFFFF'
					enable_hex = true,

					---Highlight short hex colors e.g. '#fff'
					enable_short_hex = true,

					---Highlight rgb colors, e.g. 'rgb(0 0 0)'
					enable_rgb = true,

					---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
					enable_hsl = true,

					---Highlight ansi colors, e.g '\033[0;34m'
					enable_ansi = true,

					-- Highlight hsl colors without function, e.g. '--foreground: 0 69% 69%;'
					enable_hsl_without_function = true,

					---Highlight CSS variables, e.g. 'var(--testing-color)'
					enable_var_usage = true,

					---Highlight named colors, e.g. 'green'
					enable_named_colors = true,

					---Highlight tailwind colors, e.g. 'bg-blue-500'
					enable_tailwind = true,

					---Set custom colors
					---Label must be properly escaped with '%' to adhere to `string.gmatch`
					--- :help string.gmatch
					custom_colors = {
						{ label = "%-%-theme%-primary%-color", color = "#0f1219" },
						{ label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
					},

					-- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
					exclude_filetypes = {},
					exclude_buftypes = {},
					-- Exclude buffer from highlighting e.g. 'exclude_buffer = function(bufnr) return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1000000 end'
					exclude_buffer = function(bufnr) end,
				})
			end,
		},
	}
end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
	-- add gruvbox
	{ "ellisonleao/gruvbox.nvim" },

	-- Configure LazyVim to load gruvbox
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},

	-- change trouble config
	{
		"folke/trouble.nvim",
		-- opts will be merged with the parent spec
		opts = { use_diagnostic_signs = true },
	},

	-- disable trouble
	{ "folke/trouble.nvim", enabled = false },

	-- override nvim-cmp and add cmp-emoji
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
		end,
	},

	-- change some telescope options and a keymap to browse plugin files
	{
		"nvim-telescope/telescope.nvim",
		keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
		},
		-- change some options
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
		},
	},

	-- add pyright to lspconfig
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- pyright will be automatically installed with mason and loaded with lspconfig
				pyright = {},
			},
		},
	},

	-- add tsserver and setup with typescript.nvim instead of lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			init = function()
				require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
					vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
				end)
			end,
		},
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- tsserver will be automatically installed with mason and loaded with lspconfig
				tsserver = {},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				tsserver = function(_, opts)
					require("typescript").setup({ server = opts })
					return true
				end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
	},

	-- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
	-- treesitter, mason and typescript.nvim. So instead of the above, you can use:
	{ import = "lazyvim.plugins.extras.lang.typescript" },

	-- add more treesitter parsers
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
		},
	},

	-- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
	-- would overwrite `ensure_installed` with the new value.
	-- If you'd rather extend the default config, use the code below instead:
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- add tsx and treesitter
			vim.list_extend(opts.ensure_installed, {
				"tsx",
				"typescript",
			})
		end,
	},

	-- the opts function can also be used to change the default opts:
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.sections.lualine_x, {
				function()
					return "😄"
				end,
			})
		end,
	},

	-- or you can return new options to override all the defaults
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			return {
				--[[add your custom lualine config here]]
			}
		end,
	},

	-- use mini.starter instead of alpha
	{ import = "lazyvim.plugins.extras.ui.mini-starter" },

	-- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
	{ import = "lazyvim.plugins.extras.lang.json" },

	-- add any tools you want to have installed below
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
			},
		},
	},
}

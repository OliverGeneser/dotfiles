return {
    "neovim/nvim-lspconfig",
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'j-hui/fidget.nvim',
        'MunifTanjim/prettier.nvim',
        'jose-elias-alvarez/null-ls.nvim'
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require('cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require('fidget').setup({})
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = { 'tsserver', 'lua_ls', 'rust_analyzer', 'tailwindcss', 'html' },
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require('lspconfig')
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,

                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                },
                            },
                        },
                    }
                end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = 'minimal',
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            },
        })

        local null_ls = require("null-ls")

        local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
        local event = "BufWritePre" -- or "BufWritePost"
        local async = event == "BufWritePost"

        null_ls.setup({
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.keymap.set("n", "<Leader>f", function()
                        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                    end, { buffer = bufnr, desc = "[lsp] format" })

                    -- format on save
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                    vim.api.nvim_create_autocmd(event, {
                        buffer = bufnr,
                        group = group,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, async = async })
                        end,
                        desc = "[lsp] format on save",
                    })
                end

                if client.supports_method("textDocument/rangeFormatting") then
                    vim.keymap.set("x", "<Leader>f", function()
                        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                    end, { buffer = bufnr, desc = "[lsp] format" })
                end
            end,
        })

        local prettier = require("prettier")

        prettier.setup({
            bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
            filetypes = {
                "css",
                "graphql",
                "html",
                "javascript",
                "javascriptreact",
                "json",
                "less",
                "markdown",
                "scss",
                "typescript",
                "typescriptreact",
                "yaml",
            },
        })
    end
}

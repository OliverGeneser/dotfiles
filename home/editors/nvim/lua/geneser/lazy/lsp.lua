return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                automatic_enable = true,
                ensure_installed = {
                    "astro",
                    -- "cssls",
                    "vtsls",
                    -- "cssmodules_ls",
                    "tailwindcss",
                    -- "gopls",
                    "lua_ls",
                    "biome"
                }
            })

            -- Capabilities for autocompletion
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set(
                        "n",
                        "<leader>vd",
                        "<cmd>lua vim.diagnostic.open_float()<cr>",
                        { desc = "View Diagnostics" }
                    )
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            })

            -- LSP server setup using Mason handlers
            require("mason-lspconfig").setup_handlers({
                -- Default handler for all servers
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- Custom settings for vtsls
                ["vtsls"] = function()
                    require("lspconfig").vtsls.setup({
                        capabilities = capabilities,
                        settings = {
                            typescript = {
                                tsserver = { maxTsServerMemory = 12288 },
                            },
                            experimental = {
                                completion = { entriesLimit = 3 },
                            },
                        },
                    })
                end,

                -- Custom settings for biome
                ["biome"] = function()
                    require("lspconfig").biome.setup({
                        capabilities = capabilities,
                        settings = {
                            arg = {
                                "--formatter-enabled=true",
                                "--organize-imports-enabled=true",
                            },
                        },
                    })
                end,
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            "brenoprata10/nvim-highlight-colors",
        },
        config = function()
            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Insert }
            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                },
                formatting = {
                    format = require("nvim-highlight-colors").format,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping.select_next_item({ behaviour = cmp.SelectBehavior.Insert }),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behaviour = cmp.SelectBehavior.Insert }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end,
    },
}

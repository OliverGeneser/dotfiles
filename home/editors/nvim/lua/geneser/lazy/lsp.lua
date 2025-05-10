return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            local lspconfig_defaults = require("lspconfig").util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                "force",
                lspconfig_defaults.capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            )
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                    vim.keymap.set(
                        "n",
                        "<leader>vd",
                        "<cmd>lua vim.diagnostic.open_float()<cr>",
                        { desc = "View Diagnostics" }
                    )
                    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                    vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
                    vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                end,
            })
            vim.lsp.config('vtsls', {
                root_dir = require("lspconfig").util.root_pattern(
                    ".git",
                    "pnpm-workspace.yaml",
                    "pnpm-lock.yaml",
                    "yarn.lock",
                    "package-lock.json",
                    "bun.lockb",
                    "bun.lock"
                ),
                typescript = {
                    tsserver = {
                        maxTsServerMemory = 12288,
                    },
                },
                experimental = {
                    completion = {
                        entriesLimit = 3,
                    },
                },
            })

            vim.lsp.config('tailwindcss', {
                tailwindCSS = {
                    classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                    tailwindCSS = {
                        classFunctions = { "cva", "cx" },
                    },
                },
            })

            require("mason").setup()
            -- Note: `nvim-lspconfig` needs to be in 'runtimepath' by the time you set up mason-lspconfig.nvim
            require("mason-lspconfig").setup {
                ensure_installed = {
                    "astro",
                    "cssls",
                    "vtsls",
                    "cssmodules_ls",
                    "tailwindcss",
                    "gopls",
                    "lua_ls",

                }
            }
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

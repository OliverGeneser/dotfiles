return {
    "stevearc/conform.nvim",
    event = { "BufReadPre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>f",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            javascript = { "biome", "biome-check", "biome-organize-imports" },
            typescript = { "biome", "biome-check", "biome-organize-imports" },
            javascriptreact = { "biome", "biome-check", "biome-organize-imports" },
            typescriptreact = { "biome", "biome-check", "biome-organize-imports" },
            svelte = { "biome", "biome-check", "biome-organize-imports" },
            astro = { "biome", "biome-check", "biome-organize-imports" },

            json = { "biome", "biome-check", "biome-organize-imports" },
            yaml = { "prettierd" },
            markdown = { "prettierd" },
            html = { "biome", "biome-check", "biome-organize-imports" },
            css = { "biome", "biome-check", "biome-organize-imports" },
            nix = { "alejandra" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
        -- Conform will notify you when a formatter errors
        notify_on_error = true,
        -- Conform will notify you when no formatters are available for the buffer
        notify_no_formatters = true,
    },
}

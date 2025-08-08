---@param bufnr integer
---@param ... string[][]
---@return string[]
local function first_available_list(bufnr, ...)
    local conform = require("conform")

    for i = 1, select("#", ...) do
        local formatter_list = select(i, ...) -- this is a string[]
        local all_available = true

        for _, formatter in ipairs(formatter_list) do
            local info = conform.get_formatter_info(formatter, bufnr)
            if not info or not info.available then
                all_available = false
                break
            end
        end

        if all_available then
            return formatter_list -- ✅ this is a string[]
        end
    end

    return {} -- ✅ fallback: empty string list
end

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
            javascript =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

            typescript =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

            { "biome", "biome-check", "biome-organize-imports", "prettierd" },
            javascriptreact = function(bufnr)
                return first_available_list(
                    bufnr,
                    { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                    { "prettierd" },                                      -- fallback to prettierd + injected
                    { "prettier" }                                        -- fallback to prettier only
                )
            end,

            typescriptreact = function(bufnr)
                return first_available_list(
                    bufnr,
                    { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                    { "prettierd" },                                      -- fallback to prettierd + injected
                    { "prettier" }                                        -- fallback to prettier only
                )
            end,

            svelte =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

            astro =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

            json =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

            yaml = { "prettierd" },
            markdown = { "prettierd" },
            html =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

            css =
                function(bufnr)
                    return first_available_list(
                        bufnr,
                        { "biome", "biome-check", "biome-organize-imports" }, -- use biome + injected if both available
                        { "prettierd" },                                      -- fallback to prettierd + injected
                        { "prettier" }                                        -- fallback to prettier only
                    )
                end,

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

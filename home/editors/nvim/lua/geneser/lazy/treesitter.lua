return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
                ensure_installed = {
                    "lua",
                    "typescript",
                    "tsx",
                    "astro",
                    "go",
                    "css",
                    "tailwindcss"
                },
            })
            vim.filetype.add({
                extension = {
                    css = "tailwindcss",
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 1,
        },
    },
}

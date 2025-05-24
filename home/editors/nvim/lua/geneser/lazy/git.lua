return {
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "BufReadPost" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            current_line_blame = true,
        },
    },
    {
        "OliverGeneser/ai-commit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("ai-commit").setup({
                model = "google/gemma-3-4b-it",
                auto_push = false,
            })
        end
    }
}

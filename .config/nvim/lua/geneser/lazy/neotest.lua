return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            'nvim-neotest/neotest-jest'
        },
        config = function()
            local neotest = require("neotest")
            neotest.setup({
                adapters = {
                    require('neotest-jest')({
                        jestConfigFile = function()
                            local file = vim.fn.expand('%:p')
                            if string.find(file, "/packages/") then
                                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                            end
                            if string.find(file, "/apps/") then
                                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                            end

                            return vim.fn.getcwd() .. "/jest.config.ts"
                        end,
                    })

                }
            })

            vim.keymap.set("n", "<leader>tc", function()
                neotest.run.run()
            end, { desc = "Neotest run testcases" })

            vim.keymap.set("n", "<leader>tf", function()
                neotest.run.run(vim.fn.expand("%"))
            end, { desc = "Neotest run in file" })
        end,
    },
}

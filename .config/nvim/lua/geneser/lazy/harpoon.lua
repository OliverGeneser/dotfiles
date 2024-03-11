return {
    "theprimeagen/harpoon",
    dependencies = { "plenary" },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon add file" })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon Quickmenu" })

        vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Harpoon 0" })
        vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, { desc = "Harpoon 1" })
        vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, { desc = "Harpoon 2" })
        vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, { desc = "Harpoon 3" })
    end
}

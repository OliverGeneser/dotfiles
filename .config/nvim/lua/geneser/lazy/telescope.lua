return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'plenary',
    },
    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find files (Telescope)" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find git files (Telescope)" })
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Find word (Telescope)" })
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Find Word (Telescope)" })
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Grep word (telescope)" })
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags (Telescope)" })
    end
}


return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function() 
        require('telescope').setup({
            pickers = {
                find_files = {
                    hidden = true
                },
            }
        })

        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<C-b>', builtin.buffers, { desc = 'Telescope find buffers' })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find git files' })
        vim.keymap.set('n', '<C-s>', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end,
        { desc = 'Telescope find string' }
        )
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
}

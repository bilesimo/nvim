return {
  'nvim-mini/mini.nvim',
  version = '*',
  config = function()
    require('mini.pairs').setup()
    require('mini.basics').setup({
      options = {
        basic = true,
        win_borders = 'auto'
      }
    })
    require('mini.bracketed').setup()
    require('mini.statusline').setup()
    require('mini.indentscope').setup()
    require('mini.animate').setup()
    require('mini.cmdline').setup()
    require('mini.comment').setup()

    -- Buffer delete that keeps window layout stable
    require('mini.bufremove').setup()

    -- Commands:
    --   :Bdelete   -> close current buffer
    --   :Bdelete!  -> force close (discard changes)
    vim.api.nvim_create_user_command('Bdelete', function(opts)
      require('mini.bufremove').delete(0, opts.bang)
    end, { bang = true })

    -- Optional keymaps
    vim.keymap.set('n', '<leader>bd', '<cmd>Bdelete<cr>', { desc = 'Delete buffer' })
    vim.keymap.set('n', '<leader>bD', '<cmd>Bdelete!<cr>', { desc = 'Force delete buffer' })
  end
}


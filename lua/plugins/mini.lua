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
    end
}

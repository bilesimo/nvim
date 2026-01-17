return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter').install {
            'rust',
            'javascript',
            'typescript',
            'lua',
            'c',
            'jsdoc',
            'bash',
            'vimdoc',
        }
        require('nvim-treesitter').setup {
            indent = {
                enable = true,
            },

            highlight = {
                enable = true,
            }
        }
    end
}

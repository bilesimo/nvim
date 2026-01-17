return {
    'nvim-mini/mini.icons',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    init = function()
        package.preload["nvim-web-devicons"] = function()
            require('mini.icons').mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end
}

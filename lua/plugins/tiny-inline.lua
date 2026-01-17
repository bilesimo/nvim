return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
    config = function()
        require("tiny-inline-diagnostic").setup({
            options = {
                show_source = {
                    enabled = true,
                },
            },
        })
    end
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>?",
      function()
        local wk = require("which-key")
        -- extra safety even if something triggers it super early
        vim.schedule(function()
          wk.show({ global = false })
        end)
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

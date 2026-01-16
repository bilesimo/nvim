return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      filters = {
        dotfiles = false,
      },
      view = {
        side = "right",
        width = 50,
      },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = " ",
          info = " ",
          warning = " ",
          error = " ",
        },
      },
    })

    local function find_nvim_tree_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NvimTree" then
          return win
        end
      end
      return nil
    end

    local function toggle_tree_fullscreen()
      local win = find_nvim_tree_win()
      if win then
        vim.cmd("NvimTreeClose")
        return
      end

      vim.cmd("NvimTreeFindFile")
      win = find_nvim_tree_win()
      if win then
        vim.api.nvim_set_current_win(win)
        vim.cmd("wincmd |")
        vim.cmd("wincmd _")
      end
    end

    -- Keymaps
    vim.keymap.set("n", "<leader>pv", toggle_tree_fullscreen, { desc = "NvimTree: Toggle fullscreen" })
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "NvimTree: Toggle (side) + focus" })
  end,
}

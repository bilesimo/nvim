return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        vim.opt.termguicolors = true

        -- Find the NvimTree window (if any)
        local function find_nvim_tree_win()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "NvimTree" then
                    return win
                end
            end
            return nil
        end

        -- Is the tree on the right side?
        local function is_tree_on_right(win)
            if not win then return false end
            local pos = vim.api.nvim_win_get_position(win) -- {row, col}
            local col = pos[2] or 0
            local width = vim.api.nvim_win_get_width(win)
            return (col + width) >= (vim.o.columns - 1)
        end

        local function get_tree_width_on_right()
            local win = find_nvim_tree_win()
            if not win then return nil end
            if not is_tree_on_right(win) then return nil end

            local ok, width = pcall(vim.api.nvim_win_get_width, win)
            if not ok or not width then return nil end

            return math.min(width + 1, vim.o.columns)
        end

        local function center_text(text, width)
            if width <= 0 then return "" end
            if #text >= width then return text:sub(1, width) end
            local pad = width - #text
            local left = math.floor(pad / 2)
            local right = pad - left
            return string.rep(" ", left) .. text .. string.rep(" ", right)
        end

        local function get_hl(name)
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
            if ok and hl then return hl end
            return {}
        end

        local function file_explorer_area_right()
            local width = get_tree_width_on_right()
            if not width then return {} end

            local fill = get_hl("BufferLineFill")
            local sel = get_hl("BufferLineTabSelected")
            if not fill.bg then fill = get_hl("TabLineFill") end
            if not sel.fg then sel = get_hl("TabLineSel") end

            local title = "File explorer"
            local text = center_text(title, width)

            return {
                {
                    text = text,
                    fg = sel.fg,
                    bg = fill.bg,
                    gui = "bold",
                },
            }
        end

        require("bufferline").setup({
            options = {
                always_show_bufferline = true,

                -- ✅ THIS is what makes bufferline show LSP diagnostics
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,

                custom_areas = {
                    right = function()
                        return file_explorer_area_right()
                    end,
                },

                diagnostics_indicator = function(count, diagnostics_dict)
                    if count == 0 then
                        return ""
                    end

                    -- keys: error, warning, info, hint
                    local parts = {}

                    local function add(kind, icon)
                        local n = diagnostics_dict[kind]
                        if n and n > 0 then
                            table.insert(parts, (icon .. n))
                        end
                    end

                    add("error", " ")
                    add("warning", " ")
                    add("info", " ")
                    add("hint", " ")

                    return " " .. table.concat(parts, " ")
                end,
            },
        })

        -- Ensure the tabline recalculates when NvimTree opens/closes/resizes/fullscreens
        local aug = vim.api.nvim_create_augroup("BufferlineNvimTreeRightPad", { clear = true })
        vim.api.nvim_create_autocmd({ "WinNew", "WinClosed", "WinResized", "BufWinEnter", "VimResized" }, {
            group = aug,
            callback = function()
                vim.schedule(function()
                    vim.cmd("redrawtabline")
                end)
            end,
        })
    end,
}

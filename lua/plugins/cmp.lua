return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
            { "L3MON4D3/LuaSnip", version = "v2.*" },
        },
        opts = {
            -- Use LuaSnip as the snippet engine
            snippets = { preset = "luasnip" }, -- :contentReference[oaicite:5]{index=5}

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            }, -- :contentReference[oaicite:6]{index=6}

            completion = {
                documentation = { auto_show = false },
                -- closer to nvim-cmp behavior (no auto-insert while selecting)
                list = { selection = { auto_insert = false } },
            },

            keymap = {
                preset = "enter",

                -- like cmp.confirm({ select = true })
                ["<CR>"] = { "select_and_accept", "fallback" },

                -- like your cmp mapping: next/prev if menu, else snippet jump, else fallback
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

                -- you already map <C-k> to vim.lsp.buf.signature_help in LspAttach
                ["<C-k>"] = false,
            }, -- keymap commands + disabling keys :contentReference[oaicite:7]{index=7}

            fuzzy = { implementation = "prefer_rust_with_warning" },
            appearance = { nerd_font_variant = "mono" },
        },
        opts_extend = { "sources.default" },
    },
}

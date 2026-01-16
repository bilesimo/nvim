return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  config = function()
    -------------------------------------------------------------------------
    -- LSP keymaps (buffer-local) on attach
    -- (Avoids <leader>e as requested)
    -------------------------------------------------------------------------
    local lsp_keys_group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_keys_group,
      callback = function(ev)
        local bufnr = ev.buf

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Prefer FzfLua if available, fallback to built-in LSP
        local has_fzf, fzf = pcall(require, "fzf-lua")

        -- Navigation
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")

        if has_fzf then
          map("n", "gr", fzf.lsp_references, "References")
          map("n", "<leader>fs", fzf.lsp_document_symbols, "Document symbols")
          map("n", "<leader>fS", fzf.lsp_workspace_symbols, "Workspace symbols")
        else
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "<leader>fs", vim.lsp.buf.document_symbol, "Document symbols")
          map("n", "<leader>fS", vim.lsp.buf.workspace_symbol, "Workspace symbols")
        end

        -- Hover / signature
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Actions
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

        -- Diagnostics (no <leader>e)
        map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics list")

        -- Formatting
        map("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")
      end,
    })

    -------------------------------------------------------------------------
    -- Rust
    -------------------------------------------------------------------------
    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            buildScripts = { enable = true },
            features = "all",
          },
          procMacro = { enable = true },
          formatOnSave = true,
          checkOnSave = true,
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },

          hints = {
            rangeVariablesTypes = true,
            parameterNames = true,
            constantValues = true,
            assignVariableTypes = true,
            compositeLiteralType = true,
            functionTypeParameters = true,
          },

          completeUnimported = true,
          usePlaceholders = true,

          analyses = {
            unusedparams = true,
          },
        },
      },
    })

    -------------------------------------------------------------------------
    -- TypeScript / JavaScript (ts_ls)
    -- Disable formatting here so ESLint / formatter tools can own it.
    -------------------------------------------------------------------------
    vim.lsp.config("ts_ls", {
      on_attach = function(client, _bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    -------------------------------------------------------------------------
    -- ESLint (+ fix on save)
    -------------------------------------------------------------------------
    vim.lsp.config("eslint", {
      settings = {
        workingDirectory = { mode = "auto" },
      },
    })

    local eslint_augroup = vim.api.nvim_create_augroup("EslintFixOnSave", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = eslint_augroup,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "eslint" then
          return
        end

        vim.api.nvim_create_autocmd("BufWritePre", {
          group = eslint_augroup,
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.code_action({
              apply = true,
          })
          end,
        })
      end,
    })

    -------------------------------------------------------------------------
    -- Docker
    -------------------------------------------------------------------------
    vim.lsp.config("dockerls", {})

    -------------------------------------------------------------------------
    -- Lua
    -------------------------------------------------------------------------
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = {
            checkThirdParty = true,
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = { enable = true },
          completion = { callSnippet = 'Replace' }
        },
      },
    })

    -------------------------------------------------------------------------
    -- Inlay hints toggle (kept)
    -------------------------------------------------------------------------
    vim.keymap.set("n", "<leader>h", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      require('notify')(
        vim.lsp.inlay_hint.is_enabled() and "Inlay hints enabled" or "Inlay hints disabled",
        "info"
      )
    end)

    -------------------------------------------------------------------------
    -- Mason: install + enable servers
    -------------------------------------------------------------------------
    require("mason-lspconfig").setup({
      ensure_installed = {
        "rust_analyzer",
        "ts_ls",
        "eslint",
        "dockerls",
        "lua_ls",
      },
      automatic_enable = {
        "rust_analyzer",
        "ts_ls",
        "eslint",
        "dockerls",
        "lua_ls",
      },
    })
  end,
}

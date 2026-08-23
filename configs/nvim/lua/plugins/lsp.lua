return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'folke/neodev.nvim',
  },
  config = function()
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    local on_attach = function(_, bufnr)
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      local opts = { buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end

    require('neodev').setup()

    vim.lsp.config('lua_ls', {
      on_attach = on_attach,
      settings = {
        Lua = {
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        }
      }
    })

    vim.lsp.config('pyright', {
      on_attach = on_attach,
    })

    vim.lsp.config('ts_ls', {
      on_attach = on_attach,
    })

    vim.lsp.config('rust_analyzer', {
      on_attach = on_attach,
      -- Configuración específica opcional para Rust
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = { command = "clippy" },
        },
      },
    })

    vim.lsp.config('clangd', {
      on_attach = on_attach,
    })

    vim.lsp.config('sqlls', {
      on_attach = on_attach,
    })

    vim.lsp.config('bashls', {
      on_attach = on_attach,
    })

    vim.lsp.config('html', {
      on_attach = on_attach,
    })

    -- MARKDOWN: Marksman
    vim.lsp.config('marksman', {
      on_attach = on_attach,
    })

    -- Opcional: Markdownlint (si lo instalaste)
    vim.lsp.config('markdownlint', {
      on_attach = on_attach,
    })

    vim.lsp.enable('lua_ls')
  end,
}

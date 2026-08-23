return {
  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
    },
    opts = {
      ensure_installed = {
        'lua_ls',
        'pyright',
        'ts_ls',
        'rust_analyzer',
        'clangd',
        'sqlls',
        'bashls',
        'html',
        'marksman',
      },
      automatic_installation = true,
    },
  }
}

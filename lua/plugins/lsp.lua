return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim', -- Updated to the new org name
    'mason-org/mason-lspconfig.nvim', -- Updated to the new org name
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'j-hui/fidget.nvim',
    'folke/neodev.nvim',
  },

  config = function()
    -- 1. Setup Mason 2.0+
    require('mason').setup()

    -- 2. Setup Keymaps & Autocmds (Your existing LspAttach logic)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        -- ... (Add your map('gd', ...) etc. here as you had them)
      end,
    })

    -- 3. Resolve Vue Plugin Path Dynamically
    -- This is the "magic" that makes Vue work without hardcoded paths
    local vue_plugin_path = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server'

    -- 4. Configure Servers using the new 0.11 API
    -- We use vim.lsp.config() to set the rules

    -- TypeScript / Vue Integration
    vim.lsp.config('ts_ls', {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_plugin_path,
            languages = { 'vue' },
          },
        },
      },
      -- This replaces your old on_attach formatting disable logic
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    -- Yaml Settings
    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          format = { enable = true, singleQuote = true },
          validate = true,
        },
      },
    })

    -- 5. Enable everything via Mason-LSPConfig 2.0
    -- This automatically calls vim.lsp.enable() for everything you install
    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'ts_ls',
        'volar',
        'yamlls',
        'dockerls',
        'jsonls',
      },
      automatic_enable = true, -- The 2.0+ way to replace handlers
    }

    -- 6. Tools (Formatters/Linters)
    require('mason-tool-installer').setup {
      ensure_installed = { 'stylua', 'prettier', 'markdownlint' },
    }
  end,
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'j-hui/fidget.nvim',
    'folke/neodev.nvim',
  },

  config = function()
    -- 1. Setup Mason
    require('mason').setup()

    -- 2. Define the Vue Plugin Path
    local vue_plugin_path = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server'

    -- 3. LSP Keymaps and Highlighting (LspAttach)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Keymaps
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>F', vim.lsp.buf.format, '[F]ormat')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Document Highlighting
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- 4. Server Configurations (The 0.11 Way)

    -- TypeScript & Vue
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
      on_attach = function(client)
        -- Disable formatting for ts_ls so prettier/null-ls takes over
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    -- YAML with your specific formatting rules
    vim.lsp.config('yamlls', {
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          format = {
            enable = true,
            singleQuote = true,
            printWidth = 100,
            proseWrap = 'preserve',
            bracketSpacing = true,
          },
          validate = true,
          hover = true,
          completion = true,
        },
      },
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = true
      end,
    })

    -- 5. Mason-LSPConfig Setup
    -- This handles automatic enabling and installation management
    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'dockerls',
        'jsonls',
        'sqlls',
        'volar', -- Important for Vue
        'ts_ls',
        'yamlls',
      },
      automatic_enable = true,
    }

    -- 6. Mason Tool Installer (For non-LSP tools)
    require('mason-tool-installer').setup {
      ensure_installed = {
        'stylua',
        'markdownlint',
        'prettier',
        'xmlformatter',
      },
    }
  end,
}

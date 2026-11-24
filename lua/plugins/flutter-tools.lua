return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    require('flutter-tools').setup {
      -- NOTE: Enable debugger for flutter
      decorations = {
        statusline = {
          -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
          -- this will show the current version of the flutter app from the pubspec.yaml file
          app_version = true,
          -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
          -- this will show the currently running device if an application was started with a specific
          -- device
          device = true,
          -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
          -- this will show the currently selected project configuration
          project_config = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = false,
        exception_breakpoints = {},
        -- register_configurations = function(paths)
        --   require("dap").configurations.dart = {
        --     -- <put here config that you would find in .vscode/launch.json>
        --   }
        -- end,
      },
      widget_guides = {
        enabled = true,
      },
    }

    -- flutter-tools guards ftplugin/dart with a buffer-local `flutter_tools_did_ftplugin`
    -- that survives buffer reuse, so dartls never re-attaches after `:e`, a rename, or an
    -- external edit. Re-run attach whenever a dart buffer ends up without a dartls client.
    -- See https://github.com/nvim-flutter/flutter-tools.nvim/pull/527
    vim.api.nvim_create_autocmd('BufReadPost', {
      group = vim.api.nvim_create_augroup('flutter-lsp-reattach', { clear = true }),
      pattern = '*.dart',
      callback = function(event)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_loaded(event.buf) then return end
          if next(vim.lsp.get_clients { bufnr = event.buf, name = 'dartls' }) then return end
          if vim.api.nvim_get_current_buf() ~= event.buf then return end
          require('flutter-tools.lsp').attach()
        end)
      end,
    })
  end,
}

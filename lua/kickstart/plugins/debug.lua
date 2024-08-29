-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    dap.set_log_level("DEBUG")

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()

    -- NOTE: die infos fürs aufsetzten von debug kommen hier her
    --  Install the node debugger form microsoft
      -- https://github.com/mxsdev/nvim-dap-vscode-js

    -- dap.adapters.node2 = {
    -- dap.adapters.node = {
    --   type = 'executable',
    --   command = 'node',
    --   -- TODO: wo muss ich hier nochmal hinzeigen?
    --   -- wahrscheinlich muss ich hier auf das repo des gebuildeten debug adapter zeigen
    --   -- - Debug Adapter herunterladen und builden
    --   -- - Pfad (in diesem fall hardcoded) einfügen
    --   -- NOTE: Path for linux
    --   -- args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
    --   args = {'C:\\Users\\jw\\StudioProjects\\vscode-debug\\vscode-js-debug\\out\\src\\nodeDebug.js'},
    -- }
    --
    -- -- Javascript/Node
    -- dap.configurations.javascript = {
    --   {
    --     name = 'Launch',
    --     type = 'node2',
    --     request = 'launch',
    --     -- TODO: hier muss ich noch auf den richtigen befehl verweisen
    --     -- program = '/home/dom/development/typescriptInfoJamesStrapi/node-modules/@strapi/strapi/bin/server.js develop',
    --     program = 'C:\\Users\\jw\\StudioProjects\\typescriptInfoJamesStrapi\\node-modules\\@strapi\\strapi\\bin\\server.js develop',
    --     cwd = vim.fn.getcwd(),
    --     sourceMaps = true,
    --     protocol = 'inspector',
    --     console = 'integratedTerminal',
    --   },
    --   {
    --     name = "Attach to strapi",
    --     type = "node",
    --     request = "attach",
    --     port = "9230",
    --     sourceMaps = true,
    --     trace = true,
    --   },
    --   -- {
    --   --   -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    --   --   name = 'Attach to process',
    --   --   type = 'node2',
    --   --   request = 'attach',
    --   --   processId = require'dap.utils'.pick_process,
    --   -- },
    -- }
    --
    -- -- Typescript/Node
    -- dap.configurations.typescript = {
    --   {
    --     name = 'Launch',
    --     type = 'node2',
    --     request = 'launch',
    --     -- NOTE: wtf ist das?
    --     program = '${file}',
    --     cwd = vim.fn.getcwd(),
    --     protocol = 'inspector',
    --     console = 'integratedTerminal',
    --     runtimeArgs ={"run-script","develop"},
    --     reAttach = true,
    --     trace = true
    --   },
    --   {
    --     name = "Attach to strapi",
    --     type = "node",
    --     request = "attach",
    --     port = "9230",
    --     -- processId = require'dap.utils'.pick_process,
    --   },
    --   -- Brauch ich nicht wirklich
    --   -- {
    --   --   name = "Attach to remote",
    --   --   type = "node2",
    --   --   request = "attach",
    --   --   address = "192.168.148.2",--vim.fn.input("IP: ", "", "ip") -- <- remote address here
    --   --   port = 9230
    --   -- },
    --   -- {
    --   --   -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    --   --   name = 'Attach to process',
    --   --   type = 'node2',
    --   --   request = 'attach',
    --   --   processId = require'dap.utils'.pick_process,
    --   -- },
    -- }

  end,
}

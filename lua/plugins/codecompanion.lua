local p = vim.fn.stdpath 'config' .. '/.env'

local f = io.open(p, 'r')

local api_key

if f then
  for line in f:lines() do
    for key, value in string.gmatch(line, '([^=]+)=([^=]+)') do
      if key == 'API_KEY' then
        api_key = value
      end
    end
  end

  f:close()
end

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },

  config = function()
    local cc = require 'codecompanion'

    cc.setup {
      strategies = {
        chat = { adapter = 'openai' },
        inline = { adapter = 'openai' },
      },
      adapters = {
        http = {
          openai = function()
            -- Extend the built-in OpenAI adapter
            return require('codecompanion.adapters').extend('openai', {
              env = {
                api_key = api_key,
              },
              opts = {
                -- Optional: customize model or base URL
                model = 'gpt-5.1-codex',
                -- base_url = 'https://api.openai.com/v1', -- defaults to this
              },
            })
          end,
        },
      },
    }

    -- Keymap for toggling chat
    vim.keymap.set('n', '<leader>ai', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion Chat' })
  end,
}

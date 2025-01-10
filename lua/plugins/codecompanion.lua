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
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
      },
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = api_key,
            },
          })
        end,
      },
    }
    vim.keymap.set('n', '<leader>ai', ':CodeCompanionChat Toggle<CR>')
  end,
}

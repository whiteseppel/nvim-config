return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require('which-key').setup()

    require('which-key').add{

      { '<leader>c', group = '[C]ode' },
      { '<leader>c_', hidden = true },

      { '<leader>d', group = '[D]ocument' },
      { '<leader>d_', hidden = true },

      { '<leader>f', group = '[F]lutter' },
      { '<leader>f_', hidden = true },

      { '<leader>r', group = '[R]ename' },
      { '<leader>r_', hidden = true },

      { '<leader>s', group = '[S]earch' },
      { '<leader>s_', hidden = true },

      { '<leader>t', group = 'Nvim [T]ree' },
      { '<leader>t_', hidden = true },

      { '<leader>w', group = '[W]orkspace' },
      { '<leader>w_', hidden = true },

      { '<leader>o', group = '[O]pen' },
      { '<leader>o_', hidden = true },
    }
  end,
}

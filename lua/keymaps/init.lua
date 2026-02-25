vim.api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'Nvim [T]ree [T]oggle' })

vim.keymap.set('n', '<leader>fe', ':FlutterEmulators<CR>', { noremap = true, silent = true, desc = '[f]lutter [e]mulators' })
vim.keymap.set('n', '<leader>fd', ':FlutterDevices<CR>', { noremap = true, silent = true, desc = '[f]lutter [d]evices' })
vim.keymap.set('n', '<leader>fr', ':FlutterReload<CR>', { noremap = true, silent = true, desc = '[f]lutter hot [r]eload' })
vim.keymap.set('n', '<leader>fR', ':FlutterRestart<CR>', { noremap = true, silent = true, desc = '[f]lutter [R]estart' })
vim.keymap.set('n', '<leader>fq', ':FlutterQuit<CR>', { noremap = true, silent = true, desc = '[f]lutter [q]uit' })

local command = ':lua require("telescope").extensions.flutter.commands() <CR>'
vim.keymap.set('n', '<leader>ft', command, { noremap = true, silent = true, desc = '[f]lutter [t]ools commands' })

vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

-- NOTE: go to next or previous lsp error
vim.keymap.set('n', 'gen', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Go to next LSP error' })

vim.keymap.set('n', 'gep', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Go to previous LSP error' })

vim.keymap.set('n', 'gwn', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARNING }
end, { desc = 'Go to next LSP warning' })

vim.keymap.set('n', 'gwn', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARNING }
end, { desc = 'Go to previous LSP warning' })

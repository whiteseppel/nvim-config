
-- INFO: Nvim Tree keybinds
vim.api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true , desc = 'Nvim [T]ree [T]oggle'})
-- NOTE: is this keybind needed? configuration always shows me the current file in nvim tree
vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true , desc = 'Nvim [T]ree [F]ind File'})


-- INFO: Flutter tools keybinds
vim.keymap.set('n', '<leader>fe', ':FlutterEmulators<CR>', { noremap = true, silent = true , desc = '[f]lutter [e]mulators'})
vim.keymap.set('n', '<leader>fd', ':FlutterDevices<CR>', { noremap = true, silent = true , desc = '[f]lutter [d]evices'})
vim.keymap.set('n', '<leader>fr', ':FlutterReload<CR>', { noremap = true, silent = true , desc = '[f]lutter hot [r]eload'})
vim.keymap.set('n', '<leader>fR', ':FlutterRestart<CR>', { noremap = true, silent = true , desc = '[f]lutter [R]estart'})
vim.keymap.set('n', '<leader>fq', ':FlutterQuit<CR>', { noremap = true, silent = true , desc = '[f]lutter [q]uit'})

local command = ':lua require("telescope").extensions.flutter.commands() <CR>'
vim.keymap.set('n', '<leader>ft', command , { noremap = true, silent = true , desc = '[f]lutter [t]ools commands'})

-- NOTE: not so sure is happy with this resize options
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')


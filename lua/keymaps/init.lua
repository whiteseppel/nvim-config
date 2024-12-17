-- INFO: Nvim Tree keybinds
vim.api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>',
	{ noremap = true, silent = true, desc = 'Nvim [T]ree [T]oggle' })
-- NOTE: is this keybind needed? configuration always shows me the current file in nvim tree
vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFile<CR>',
	{ noremap = true, silent = true, desc = 'Nvim [T]ree [F]ind File' })


-- INFO: Flutter tools keybinds
vim.keymap.set('n', '<leader>fe', ':FlutterEmulators<CR>',
	{ noremap = true, silent = true, desc = '[f]lutter [e]mulators' })
vim.keymap.set('n', '<leader>fd', ':FlutterDevices<CR>', { noremap = true, silent = true, desc = '[f]lutter [d]evices' })
vim.keymap.set('n', '<leader>fr', ':FlutterReload<CR>',
	{ noremap = true, silent = true, desc = '[f]lutter hot [r]eload' })
vim.keymap.set('n', '<leader>fR', ':FlutterRestart<CR>', { noremap = true, silent = true, desc = '[f]lutter [R]estart' })
vim.keymap.set('n', '<leader>fq', ':FlutterQuit<CR>', { noremap = true, silent = true, desc = '[f]lutter [q]uit' })

local command = ':lua require("telescope").extensions.flutter.commands() <CR>'
vim.keymap.set('n', '<leader>ft', command, { noremap = true, silent = true, desc = '[f]lutter [t]ools commands' })

-- NOTE: not so sure is happy with this resize options
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')

vim.keymap.set('n', '<leader>ot', function()
  -- Create a buffer for the terminal
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Get the editor dimensions
  local width = vim.o.columns
  local height = vim.o.lines

  -- Set floating window dimensions (adjust as needed)
  local win_width = math.floor(width * 0.8)
  local win_height = math.floor(height * 0.8)
  local row = math.floor((height - win_height) / 2) -- Centered vertically
  local col = math.floor((width - win_width) / 2)  -- Centered horizontally

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'double', -- Can be 'single', 'double', 'rounded', 'solid', or 'none'
  })

  -- Start a terminal in the buffer
  vim.fn.termopen("powershell")

  -- Optional: Set the buffer to close when the terminal is exited
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    callback = function()
      vim.api.nvim_buf_delete(buf, { force = true })
    end,
  })

  -- Focus the floating terminal window
  vim.api.nvim_set_current_win(win)
  vim.cmd.startinsert()
end)

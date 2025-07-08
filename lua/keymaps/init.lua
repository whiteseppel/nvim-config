-- INFO: Nvim Tree keybinds
vim.api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>',
	{ noremap = true, silent = true, desc = 'Nvim [T]ree [T]oggle' })
-- -- NOTE: is this keybind needed? configuration always shows me the current file in nvim tree
-- vim.keymap.set('n', '<leader>tf', ':NvimTreeFindFile<CR>',
-- 	{ noremap = true, silent = true, desc = 'Nvim [T]ree [F]ind File' })

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

-- NOTE: open new terminal window on windows
vim.keymap.set('n', '<leader>nt', function()
	os.execute('wt -w 0 nt -d .')
end, { desc = 'Open a [n]ew [t]erminal' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

local state = {
	floating = {
		buf = -1,
		win = -1,
	}
}

local function toggle_terminal(opts)
	opts = opts or {}
	local buf = nil


	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local width = vim.o.columns
	local height = vim.o.lines

	local win_width = math.floor(width * 0.8)
	local win_height = math.floor(height * 0.8)
	local row = math.floor((height - win_height) / 2)
	local col = math.floor((width - win_width) / 2)

	local win_config = {
		relative = 'editor',
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded',
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	vim.api.nvim_create_autocmd("TermClose", {
		buffer = buf,
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})

	return { buf = buf, win = win }
end

vim.keymap.set('n', '<leader>ot',
	function()
		if not vim.api.nvim_win_is_valid(state.floating.win) then
			state.floating = toggle_terminal { buf = state.floating.buf }
			-- print(vim.inspect(state.floating))
			if vim.bo[state.floating.buf].buftype ~= "terminal" then
				vim.fn.termopen("powershell")
			end
		else
			vim.api.nvim_win_hide(state.floating.win)
		end
	end
)

local M = {}

-- Configuration
local config = {
	width = 0.8,
	height = 0.8,
	border = "rounded",
	winblend = 3,
}

-- Internal state
local state = {
	terminals = {}, -- List of {buf, win}
	current_idx = 0,
}

--- Calculate window options for the floating terminal
local function get_win_opts(idx)
	local width = math.floor(vim.o.columns * config.width)
	local height = math.floor(vim.o.lines * config.height)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	return {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = config.border,
		title = string.format(" Terminal %d ", idx),
		title_pos = "center",
	}
end

--- Hide the currently active terminal window if it exists
local function hide_current()
	local term = state.terminals[state.current_idx]
	if term and vim.api.nvim_win_is_valid(term.win) then
		vim.api.nvim_win_hide(term.win)
		term.win = -1
	end
end

--- Open or create a terminal at the specified index
local function open_term(idx)
	local term = state.terminals[idx]

	-- Create buffer if it doesn't exist or is invalid
	if not term or not vim.api.nvim_buf_is_valid(term.buf) then
		local buf = vim.api.nvim_create_buf(false, true)
		term = { buf = buf, win = -1 }
		state.terminals[idx] = term
	end

	-- Open the floating window
	term.win = vim.api.nvim_open_win(term.buf, true, get_win_opts(idx))
	vim.wo[term.win].winblend = config.winblend

	-- Initialize terminal if not already done
	if vim.bo[term.buf].buftype ~= "terminal" then
		vim.fn.termopen(vim.o.shell)
		vim.bo[term.buf].buflisted = false
	end

	vim.cmd("startinsert")
end

--- Toggle the current terminal
function M.toggle()
	if state.current_idx == 0 then
		state.current_idx = 1
		open_term(state.current_idx)
		return
	end

	local term = state.terminals[state.current_idx]
	if term and vim.api.nvim_win_is_valid(term.win) then
		hide_current()
	else
		open_term(state.current_idx)
	end
end

--- Create and switch to a new terminal instance
function M.new_terminal()
	hide_current()
	state.current_idx = #state.terminals + 1
	open_term(state.current_idx)
end

--- Cycle through terminal instances
function M.cycle(delta)
	local count = #state.terminals
	if count <= 1 then
		return
	end

	hide_current()

	state.current_idx = state.current_idx + delta
	if state.current_idx > count then
		state.current_idx = 1
	elseif state.current_idx < 1 then
		state.current_idx = count
	end

	open_term(state.current_idx)
end

-- Set up keymaps
local function setup_keymaps()
	local opts = { silent = true }
	vim.keymap.set({ "n", "t" }, "<C-t>", M.toggle, vim.tbl_extend("force", opts, { desc = "Toggle Terminal" }))
	vim.keymap.set({ "n", "i", "t" }, "<C-S-t>", M.new_terminal, vim.tbl_extend("force", opts, { desc = "New Terminal" }))
	vim.keymap.set({ "n", "i", "t" }, "<A-n>", function()
		M.cycle(1)
	end, vim.tbl_extend("force", opts, { desc = "Next Terminal" }))
	vim.keymap.set({ "n", "i", "t" }, "<A-p>", function()
		M.cycle(-1)
	end, vim.tbl_extend("force", opts, { desc = "Prev Terminal" }))
end

-- Set up autocommands
local function setup_autocmds()
	local group = vim.api.nvim_create_augroup("CustomTerminal", { clear = true })

	vim.api.nvim_create_autocmd("TermOpen", {
		group = group,
		callback = function()
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.signcolumn = "no"
			vim.bo.buflisted = false
			vim.cmd("startinsert")
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "term://*",
		callback = function()
			vim.cmd("startinsert")
		end,
	})
end

-- Initialize
setup_keymaps()
setup_autocmds()

return M

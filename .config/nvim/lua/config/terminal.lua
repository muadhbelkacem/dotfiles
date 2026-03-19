local M = {}

-- Configuration
local config = {
	width = 0.4, -- 40% of the screen width
}

-- Internal state
local state = {
	terminals = {}, -- List of {buf, win, name}
	current_idx = 0,
	last_width = nil,
}

--- Hide the currently active terminal window if it exists
local function hide_current()
	local term = state.terminals[state.current_idx]
	if term and vim.api.nvim_win_is_valid(term.win) then
		-- Save current width to state to share it across all terminals
		state.last_width = vim.api.nvim_win_get_width(term.win)
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
		term = { buf = buf, win = -1, name = nil }
		state.terminals[idx] = term
	end

	-- Use saved width if available, otherwise use default 40%
	local width = state.last_width or math.floor(vim.o.columns * config.width)
	vim.cmd("botright " .. width .. "vsplit")
	term.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(term.win, term.buf)

	-- Keep naming using winbar
	local display_name = term.name or string.format("Terminal %d", idx)
	vim.wo[term.win].winbar = string.format("%%#TabLine# %%= %s %%= %%*", display_name)

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
		if #state.terminals > 0 then
			state.current_idx = 1
		else
			M.new_terminal()
			return
		end
	end

	local term = state.terminals[state.current_idx]
	if term and vim.api.nvim_win_is_valid(term.win) then
		-- If we are in the terminal window, hide it
		if vim.api.nvim_get_current_win() == term.win then
			hide_current()
		else
			-- If we are elsewhere, focus the terminal window
			vim.api.nvim_set_current_win(term.win)
			vim.cmd("startinsert")
		end
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

--- Rename the current terminal
function M.rename_current()
	local term = state.terminals[state.current_idx]
	if not term then
		return
	end

	vim.ui.input({ prompt = "Terminal Name: " }, function(input)
		if input and input ~= "" then
			term.name = input
			if term.win and vim.api.nvim_win_is_valid(term.win) then
				vim.wo[term.win].winbar = string.format("%%#TabLine# %%= %s %%= %%*", input)
			end
		end
	end)
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
	vim.keymap.set({ "n", "i", "t" }, "<A-r>", M.rename_current, vim.tbl_extend("force", opts, { desc = "Rename Terminal" }))

	-- Resizing terminal width
	vim.keymap.set({ "n", "t" }, "<A-h>", "<cmd>vertical resize +2<cr>", vim.tbl_extend("force", opts, { desc = "Increase Terminal Width" }))
	vim.keymap.set({ "n", "t" }, "<A-l>", "<cmd>vertical resize -2<cr>", vim.tbl_extend("force", opts, { desc = "Decrease Terminal Width" }))

	-- Terminal navigation
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
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

	vim.api.nvim_create_autocmd("TermClose", {
		group = group,
		callback = function(args)
			local buf = args.buf
			-- Find and remove from state
			local idx_to_remove = -1
			for i, t in ipairs(state.terminals) do
				if t.buf == buf then
					idx_to_remove = i
					break
				end
			end

			if idx_to_remove ~= -1 then
				table.remove(state.terminals, idx_to_remove)
				-- Update current_idx
				if idx_to_remove == state.current_idx then
					if #state.terminals == 0 then
						state.current_idx = 0
					else
						state.current_idx = math.max(1, math.min(state.current_idx, #state.terminals))
					end
				elseif idx_to_remove < state.current_idx then
					state.current_idx = state.current_idx - 1
				end
			end

			-- Automatically delete the buffer and close the window
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end)
		end,
	})
end

-- Initialize
setup_keymaps()
setup_autocmds()

return M

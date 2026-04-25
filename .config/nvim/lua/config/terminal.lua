local M = {}

-- Internal state
local state = {
	bufs = {}, -- List of terminal buffers
	current_idx = 0,
	win = -1,
}

--- Update the window title (winbar) to show tab info
local function update_ui()
	if vim.api.nvim_win_is_valid(state.win) then
		if #state.bufs > 0 then
			local status = string.format(" Terminal %d/%d ", state.current_idx, #state.bufs)
			vim.wo[state.win].winbar = status
		else
			vim.wo[state.win].winbar = ""
		end
	end
end

--- Hide the terminal window if it exists
local function hide_term()
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
	end
end

--- Create a new terminal buffer
--- @param cwd string|nil
local function create_term_buf(cwd)
	local buf = vim.api.nvim_create_buf(false, true)

	-- Initialize terminal in the buffer
	vim.api.nvim_buf_call(buf, function()
		if cwd and cwd ~= "" then
			vim.fn.termopen(vim.o.shell, { cwd = cwd })
		else
			-- Passing an empty table {} to termopen often results in "expected dictionary"
			-- because Vim interprets empty Lua tables as lists.
			-- Omitting the second argument avoids this.
			vim.fn.termopen(vim.o.shell)
		end
	end)

	vim.bo[buf].buflisted = false
	return buf
end

--- Open or create the terminal window
--- @param cwd string|nil
local function open_term(cwd)
	-- If no buffers exist, create the first one
	if #state.bufs == 0 then
		table.insert(state.bufs, create_term_buf(cwd))
		state.current_idx = 1
	end

	-- Validate current buffer
	local buf = state.bufs[state.current_idx]
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		-- Clean up invalid buffer and retry
		for i = #state.bufs, 1, -1 do
			if not vim.api.nvim_buf_is_valid(state.bufs[i]) then
				table.remove(state.bufs, i)
			end
		end
		state.current_idx = math.max(1, math.min(state.current_idx, #state.bufs))
		return open_term(cwd)
	end

	-- Open in a fullscreen floating window
	local win_opts = {
		relative = "editor",
		width = vim.o.columns,
		height = vim.o.lines,
		row = 0,
		col = 0,
		style = "minimal",
		border = "none",
	}
	state.win = vim.api.nvim_open_win(buf, true, win_opts)
	update_ui()
	vim.cmd("startinsert")
end

--- Toggle the terminal
--- @param cwd string|nil
function M.toggle(cwd)
	if vim.api.nvim_win_is_valid(state.win) then
		if vim.api.nvim_get_current_win() == state.win then
			hide_term()
		else
			vim.api.nvim_set_current_win(state.win)
			vim.cmd("startinsert")
		end
	else
		open_term(cwd)
	end
end

--- Create a new terminal tab
function M.new(cwd)
	local buf = create_term_buf(cwd)
	table.insert(state.bufs, buf)
	state.current_idx = #state.bufs

	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_set_buf(state.win, buf)
		update_ui()
		vim.cmd("startinsert")
	else
		open_term(cwd)
	end
end

--- Switch to the next terminal tab
function M.next()
	if #state.bufs <= 1 then return end
	state.current_idx = (state.current_idx % #state.bufs) + 1
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_set_buf(state.win, state.bufs[state.current_idx])
		update_ui()
		vim.cmd("startinsert")
	end
end

--- Switch to the previous terminal tab
function M.prev()
	if #state.bufs <= 1 then return end
	state.current_idx = (state.current_idx - 2 + #state.bufs) % #state.bufs + 1
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_set_buf(state.win, state.bufs[state.current_idx])
		update_ui()
		vim.cmd("startinsert")
	end
end

-- Set up keymaps
local function setup_keymaps()
	local opts = { silent = true }

	-- Toggle terminal
	vim.keymap.set({ "n", "t" }, "<C-t>", function()
		M.toggle()
	end, { desc = "Toggle Terminal", silent = true })

	-- New terminal tab
	vim.keymap.set({ "n", "t" }, "<C-S-t>", function()
		M.new()
	end, { desc = "New Terminal Tab", silent = true })

	-- Terminal escape and navigation
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)

	-- Tab switching
	vim.keymap.set("t", "<C-Tab>", function()
		M.next()
	end, { desc = "Next Terminal Tab", silent = true })

	vim.keymap.set("t", "<C-S-Tab>", function()
		M.prev()
	end, { desc = "Previous Terminal Tab", silent = true })
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
			-- Auto-insert mode when entering a terminal buffer
			vim.cmd("startinsert")
		end,
	})

	vim.api.nvim_create_autocmd("TermClose", {
		group = group,
		callback = function(args)
			vim.schedule(function()
				-- Find and remove buffer from state.bufs
				local removed = false
				for i, buf in ipairs(state.bufs) do
					if buf == args.buf then
						table.remove(state.bufs, i)
						removed = true
						if state.current_idx > #state.bufs then
							state.current_idx = math.max(1, #state.bufs)
						end
						break
					end
				end

				if not removed then return end

				-- If no more terminals, close the window
				if #state.bufs == 0 then
					if state.win ~= -1 and vim.api.nvim_win_is_valid(state.win) then
						vim.api.nvim_win_close(state.win, true)
						state.win = -1
					end
				else
					-- If the closed buffer was active in the window, switch to another
					if vim.api.nvim_win_is_valid(state.win) and vim.api.nvim_win_get_buf(state.win) == args.buf then
						vim.api.nvim_win_set_buf(state.win, state.bufs[state.current_idx])
						update_ui()
						vim.cmd("startinsert")
					end
				end

				-- Delete the buffer
				if vim.api.nvim_buf_is_valid(args.buf) then
					vim.api.nvim_buf_delete(args.buf, { force = true })
				end
			end)
		end,
	})
end

-- Initialize
setup_keymaps()
setup_autocmds()

return M

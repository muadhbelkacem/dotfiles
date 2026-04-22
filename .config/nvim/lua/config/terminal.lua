local M = {}

-- Internal state
local state = {
	buf = -1,
	win = -1,
}

--- Hide the terminal window if it exists
local function hide_term()
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
	end
end

--- Open or create the terminal
local function open_term()
	-- Create buffer if it doesn't exist or is invalid
	if not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
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
	state.win = vim.api.nvim_open_win(state.buf, true, win_opts)

	-- Initialize terminal if not already done
	if vim.bo[state.buf].buftype ~= "terminal" then
		vim.fn.termopen(vim.o.shell)
		vim.bo[state.buf].buflisted = false
	end

	vim.cmd("startinsert")
end

--- Toggle the terminal
function M.toggle()
	if vim.api.nvim_win_is_valid(state.win) then
		-- If we are in the terminal window, hide it
		if vim.api.nvim_get_current_win() == state.win then
			hide_term()
		else
			-- If we are elsewhere, focus the terminal window
			vim.api.nvim_set_current_win(state.win)
			vim.cmd("startinsert")
		end
	else
		open_term()
	end
end

-- Set up keymaps
local function setup_keymaps()
	local opts = { silent = true }
	vim.keymap.set({ "n", "t" }, "<leader>t", M.toggle, vim.tbl_extend("force", opts, { desc = "Toggle Terminal" }))

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
			if buf == state.buf then
				state.buf = -1
				state.win = -1
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

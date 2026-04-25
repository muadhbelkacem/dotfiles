local M = {}
local uv = vim.uv or vim.loop

-- Disable netrw to use our custom explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Remove the default FileExplorer autocommands to prevent E117 errors
pcall(vim.api.nvim_del_augroup_by_name, "FileExplorer")

local state = {
	cwd = nil,
	selected = nil,
	wins = { parent = nil, current = nil, preview = nil },
	bufs = { parent = nil, current = nil, preview = nil },
	active = false,
	prev_win = nil,
	history = {}, -- Store last selected item for each directory
	show_hidden = false,
}

-- Helper to normalize paths
local function norm(path)
	if not path or path == "" then
		return ""
	end
	local p = vim.fn.fnamemodify(path, ":p")
	if p:len() > 1 and p:sub(-1) == "/" then
		p = p:sub(1, -2)
	end
	return p
end

local function get_files(path)
	local files = {}
	local handle = uv.fs_scandir(path)
	if not handle then
		return {}
	end
	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then
			break
		end
		if name ~= "." and name ~= ".." then
			if state.show_hidden or name:sub(1, 1) ~= "." then
				table.insert(files, { name = name, type = type })
			end
		end
	end
	table.sort(files, function(a, b)
		if a.type ~= b.type then
			return a.type == "directory"
		end
		return a.name:lower() < b.name:lower()
	end)
	return files
end

local function fill_buf(buf, files, selected_name)
	if not buf or type(buf) ~= "number" or not vim.api.nvim_buf_is_valid(buf) then
		return 1
	end
	local lines = {}
	local idx = 1
	for i, f in ipairs(files) do
		local name = f.name:gsub("\n", "") -- Sanitize filename
		local icon = f.type == "directory" and " " or " "
		table.insert(lines, string.format(" %s %s", icon, name))
		if selected_name and f.name == selected_name then
			idx = i
		end
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	return idx
end

function M.update_preview()
	if not state.active then
		return
	end
	local win = state.wins.current
	if not win or not vim.api.nvim_win_is_valid(win) then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(win)
	local line = cursor[1]
	local current_files = get_files(state.cwd)
	local target = current_files[line]

	if not target then
		if state.bufs.preview and vim.api.nvim_buf_is_valid(state.bufs.preview) then
			vim.api.nvim_buf_set_lines(state.bufs.preview, 0, -1, false, {})
		end
		return
	end

	state.selected = target.name
	state.history[state.cwd] = target.name
	local path = state.cwd .. "/" .. target.name

	if target.type == "directory" then
		local preview_files = get_files(path)
		fill_buf(state.bufs.preview, preview_files)
		vim.bo[state.bufs.preview].syntax = ""
	else
		local ok, lines = pcall(vim.fn.readfile, path, "b", 100)
		if not ok then
			lines = { " [Binary or Unreadable File] " }
		end

		local processed_lines = {}
		for _, l in ipairs(lines) do
			local sanitized = tostring(l):gsub("\n", "")
			table.insert(processed_lines, sanitized)
		end

		vim.api.nvim_buf_set_lines(state.bufs.preview, 0, -1, false, processed_lines)

		local ft = vim.filetype.match({ filename = path })
		if ft then
			vim.bo[state.bufs.preview].ft = ft
		end
	end
end

function M.render()
	if not state.active then
		return
	end

	local current_files = get_files(state.cwd)
	local current_idx = fill_buf(state.bufs.current, current_files, state.selected)
	pcall(vim.api.nvim_win_set_cursor, state.wins.current, { current_idx, 0 })

	local parent_path = norm(vim.fn.fnamemodify(state.cwd, ":h"))
	if parent_path ~= state.cwd then
		local parent_files = get_files(parent_path)
		local parent_idx = fill_buf(state.bufs.parent, parent_files, vim.fn.fnamemodify(state.cwd, ":t"))
		pcall(vim.api.nvim_win_set_cursor, state.wins.parent, { parent_idx, 0 })
	else
		vim.api.nvim_buf_set_lines(state.bufs.parent, 0, -1, false, { " [Root] " })
	end

	M.update_preview()
end

function M.nav_h()
	local parent = norm(vim.fn.fnamemodify(state.cwd, ":h"))
	if parent == state.cwd then
		return
	end
	state.selected = vim.fn.fnamemodify(state.cwd, ":t")
	state.cwd = parent
	M.render()
end

function M.nav_l()
	local win = state.wins.current
	local cursor = vim.api.nvim_win_get_cursor(win)
	local current_files = get_files(state.cwd)
	local target = current_files[cursor[1]]
	if not target then
		return
	end

	if target.type == "directory" then
		state.history[state.cwd] = target.name
		state.cwd = norm(state.cwd .. "/" .. target.name)
		state.selected = state.history[state.cwd]
		M.render()
	end
end

function M.open_entry()
	local win = state.wins.current
	local cursor = vim.api.nvim_win_get_cursor(win)
	local current_files = get_files(state.cwd)
	local target = current_files[cursor[1]]
	if not target then
		return
	end

	if target.type == "directory" then
		state.history[state.cwd] = target.name
		state.cwd = norm(state.cwd .. "/" .. target.name)
		state.selected = state.history[state.cwd]
		M.render()
	else
		local path = state.cwd .. "/" .. target.name
		M.close()
		vim.cmd("edit " .. vim.fn.fnameescape(path))
	end
end

function M.create()
	vim.ui.input({ prompt = "New name (ends with / for dir): " }, function(input)
		if not input or input == "" then
			return
		end
		local path = state.cwd .. "/" .. input
		if input:sub(-1) == "/" then
			vim.fn.mkdir(path, "p")
		else
			vim.fn.writefile({}, path)
		end
		M.render()
	end)
end

function M.rename()
	local win = state.wins.current
	local cursor = vim.api.nvim_win_get_cursor(win)
	local current_files = get_files(state.cwd)
	local target = current_files[cursor[1]]
	if not target then
		return
	end

	vim.ui.input({ prompt = "Rename to: ", default = target.name }, function(input)
		if not input or input == "" or input == target.name then
			return
		end
		local old_path = state.cwd .. "/" .. target.name
		local new_path = state.cwd .. "/" .. input
		uv.fs_rename(old_path, new_path)
		M.render()
	end)
end

function M.delete()
	local win = state.wins.current
	local cursor = vim.api.nvim_win_get_cursor(win)
	local current_files = get_files(state.cwd)
	local target = current_files[cursor[1]]
	if not target then
		return
	end

	local confirm = vim.fn.confirm("Delete " .. target.name .. "?", "&Yes\n&No", 2)
	if confirm == 1 then
		local path = state.cwd .. "/" .. target.name
		vim.fn.delete(path, "rf")
		M.render()
	end
end

function M.toggle_hidden()
	state.show_hidden = not state.show_hidden
	M.render()
end

function M.open_terminal()
	local term = require("config.terminal")
	local path = state.cwd
	local win = state.wins.current
	local cursor = vim.api.nvim_win_get_cursor(win)
	local current_files = get_files(state.cwd)
	local target = current_files[cursor[1]]

	if target and target.type == "directory" then
		path = state.cwd .. "/" .. target.name
	end

	M.close()
	term.new(path)
end

function M.close()
	if not state.active then
		return
	end
	state.active = false

	for k, win in pairs(state.wins) do
		if win and vim.api.nvim_win_is_valid(win) then
			pcall(vim.api.nvim_win_close, win, true)
		end
		state.wins[k] = nil
	end

	for k, buf in pairs(state.bufs) do
		if buf and vim.api.nvim_buf_is_valid(buf) then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
		state.bufs[k] = nil
	end

	if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
		pcall(vim.api.nvim_set_current_win, state.prev_win)
	end
end

function M.toggle(dir)
	local win_valid = state.wins.current and vim.api.nvim_win_is_valid(state.wins.current)

	-- If already active
	if state.active and win_valid then
		if dir then
			-- Just update the directory if one was provided
			state.cwd = norm(dir)
			state.selected = state.history[state.cwd]
			M.render()
			return
		else
			-- Otherwise close it (toggle behavior)
			M.close()
			return
		end
	end

	-- Cleanup if partially active/invalid
	if state.active and not win_valid then
		M.close()
	end

	state.prev_win = vim.api.nvim_get_current_win()
	state.active = true

	-- Determine initial directory
	if dir then
		state.cwd = norm(dir)
		state.selected = state.history[state.cwd]
	elseif not state.cwd then
		local buf_name = vim.api.nvim_buf_get_name(0)
		if buf_name ~= "" and (vim.fn.filereadable(buf_name) == 1 or vim.fn.isdirectory(buf_name) == 1) then
			if vim.fn.isdirectory(buf_name) == 1 then
				state.cwd = norm(buf_name)
				state.selected = state.history[state.cwd]
			else
				state.cwd = norm(vim.fn.fnamemodify(buf_name, ":p:h"))
				state.selected = vim.fn.fnamemodify(buf_name, ":t")
			end
		else
			state.cwd = norm(vim.fn.getcwd())
			state.selected = state.history[state.cwd]
		end
	else
		-- If we already have a directory, check if current buffer is in it to update selection
		local buf_name = vim.api.nvim_buf_get_name(0)
		if buf_name ~= "" and vim.fn.filereadable(buf_name) == 1 then
			local buf_dir = norm(vim.fn.fnamemodify(buf_name, ":p:h"))
			if buf_dir == state.cwd then
				state.selected = vim.fn.fnamemodify(buf_name, ":t")
			else
				state.selected = state.history[state.cwd]
			end
		else
			state.selected = state.history[state.cwd]
		end
	end

	-- Create buffers
	state.bufs.parent = vim.api.nvim_create_buf(false, true)
	state.bufs.current = vim.api.nvim_create_buf(false, true)
	state.bufs.preview = vim.api.nvim_create_buf(false, true)

	for _, buf in pairs(state.bufs) do
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].swapfile = false
		vim.bo[buf].buflisted = false
		vim.bo[buf].filetype = "netrw"
	end

	-- Setup windows
	local explorer_height = 15
	vim.cmd("silent botright " .. explorer_height .. "split")
	state.wins.parent = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(state.wins.parent, state.bufs.parent)

	vim.cmd("silent rightbelow vsplit")
	state.wins.current = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(state.wins.current, state.bufs.current)

	vim.cmd("silent rightbelow vsplit")
	state.wins.preview = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(state.wins.preview, state.bufs.preview)

	-- Window options
	for _, win in pairs(state.wins) do
		vim.wo[win].number = false
		vim.wo[win].relativenumber = false
		vim.wo[win].signcolumn = "no"
		vim.wo[win].winfixheight = true
	end
	vim.wo[state.wins.current].cursorline = true

	local total_width = vim.o.columns
	vim.api.nvim_win_set_width(state.wins.parent, math.floor(total_width * 0.2))
	vim.api.nvim_win_set_width(state.wins.current, math.floor(total_width * 0.3))

	-- Keymaps
	local opts = { buffer = state.bufs.current, silent = true }
	vim.keymap.set("n", "h", M.nav_h, opts)
	vim.keymap.set("n", "l", M.nav_l, opts)
	vim.keymap.set("n", "o", M.open_entry, opts)
	vim.keymap.set("n", "<CR>", M.open_entry, opts)
	vim.keymap.set("n", "a", M.create, opts)
	vim.keymap.set("n", "r", M.rename, opts)
	vim.keymap.set("n", "d", M.delete, opts)
	vim.keymap.set("n", ".", M.toggle_hidden, opts)
	vim.keymap.set("n", "q", M.close, opts)
	vim.keymap.set("n", "<Esc>", M.close, opts)
	vim.keymap.set("n", "t", M.open_terminal, opts)

	-- Update preview on move
	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = state.bufs.current,
		callback = M.update_preview,
	})

	M.render()
	vim.api.nvim_set_current_win(state.wins.current)
end

-- Autocommand to hijack directory buffers
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("NetrwReplacement", { clear = true }),
	callback = function(args)
		local buf = args.buf or 0
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local buf_name = vim.api.nvim_buf_get_name(buf)
		if vim.fn.isdirectory(buf_name) == 1 then
			local dir = norm(buf_name)

			vim.schedule(function()
				-- Re-check state inside schedule to prevent race conditions
				if vim.api.nvim_buf_is_valid(buf) and vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf)) == 1 then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
				M.toggle(dir)
			end)
		end
	end,
})

vim.keymap.set("n", "<leader>e", M.toggle, { desc = "Toggle 3-panel explorer" })

return M

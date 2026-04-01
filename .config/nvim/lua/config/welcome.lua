local M = {}

function M.draw()
  local buf = vim.api.nvim_get_current_buf()
  local content, actions = {}, {}
  local menu = {
    { "f", "Find File", "Telescope find_files" },
    { "n", "New File  ", "enew" },
    { "q", "Quit      ", "qa" },
  }

  local function add(text, fn)
    local shift = math.floor((vim.o.columns - vim.fn.strdisplaywidth(text)) / 2)
    table.insert(content, string.rep(" ", shift) .. text)
    actions[#content] = fn
  end

  for _ = 1, math.floor(vim.o.lines / 3) do table.insert(content, "") end

  for _, m in ipairs(menu) do
    add(string.format(" [%s] %s ", m[1], m[2]), function() vim.cmd(m[3]) end)
    vim.keymap.set("n", m[1], function() vim.cmd(m[3]) end, { buffer = buf, nowait = true })
  end

  local files = vim.tbl_filter(function(f) return vim.fn.filereadable(f) == 1 end, vim.v.oldfiles)
  local start, finish
  if #files > 0 then
    add("", nil)
    add("--- Recent Files ---", nil)
    start = #content + 1
    for i = 1, math.min(5, #files) do
      local f = files[i]
      add(vim.fn.fnamemodify(f, ":~:."), function() vim.cmd("edit " .. vim.fn.fnameescape(f)) end)
    end
    finish = #content
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.cmd "setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable nonumber norelativenumber cursorline signcolumn=no statusline=\\ "

  if start and finish then
    pcall(vim.api.nvim_win_set_cursor, 0, { start, 0 })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = buf,
      callback = function()
        local curr = vim.api.nvim_win_get_cursor(0)[1]
        if curr < start then
          vim.api.nvim_win_set_cursor(0, { start, 0 })
        elseif curr > finish then
          vim.api.nvim_win_set_cursor(0, { finish, 0 })
        end
      end,
    })
  end

  vim.keymap.set("n", "<CR>", function()
    local fn = actions[vim.api.nvim_win_get_cursor(0)[1]]
    if fn then fn() end
  end, { buffer = buf, silent = true })
end

function M.setup()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("WelcomeScreen", { clear = true }),
    callback = function()
      if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.bo.filetype == "" then
        M.draw()
      end
    end,
  })
end

return M

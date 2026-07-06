local M = {}

local function get_term_bufs()
  return vim.tbl_filter(function(b)
    return vim.bo[b].buftype == "terminal"
  end, vim.api.nvim_list_bufs())
end

local function show_terminals(focus_buf)
  local term_bufs = get_term_bufs()
  for _, b in ipairs(term_bufs) do
    local wins = vim.fn.win_findbuf(b)
    if #wins == 0 then
      vim.cmd("tab sbuf " .. b)
      wins = vim.fn.win_findbuf(b)
    end
    if #wins > 0 then
      vim.api.nvim_set_current_win(wins[1])
      vim.cmd("only")
    end
  end

  if focus_buf and focus_buf ~= -1 then
    local wins = vim.fn.win_findbuf(focus_buf)
    if #wins > 0 then
      vim.api.nvim_set_current_win(wins[1])
    end
  elseif #term_bufs > 0 then
    local wins = vim.fn.win_findbuf(term_bufs[1])
    if #wins > 0 then
      vim.api.nvim_set_current_win(wins[1])
    end
  end
end

local term_count = #get_term_bufs()

function M.new_terminal()
  term_count = term_count + 1
  vim.cmd("tab terminal")
  vim.cmd("file term" .. term_count)
  show_terminals(vim.api.nvim_get_current_buf())
end

function M.toggle_terminal()
  local term_bufs = get_term_bufs()

  if #term_bufs == 0 then
    M.new_terminal()
    return
  end

  local curr_buf = vim.api.nvim_get_current_buf()
  local is_focused_term = vim.bo[curr_buf].buftype == "terminal"

  if not is_focused_term then
    show_terminals()
    return
  end

  local term_wids = {}
  for _, b in ipairs(term_bufs) do
    for _, wid in ipairs(vim.fn.win_findbuf(b)) do
      table.insert(term_wids, wid)
    end
  end

  local cur_wid = vim.api.nvim_get_current_win()
  for _, wid in ipairs(term_wids) do
    if wid ~= cur_wid then
      if vim.api.nvim_win_is_valid(wid) then
        vim.api.nvim_win_hide(wid)
      end
    end
  end

  if #vim.api.nvim_list_wins() > 1 or #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd("hide")
  end
end

return M

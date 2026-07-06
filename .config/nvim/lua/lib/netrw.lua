local M = {}

local netrw_last_dir = vim.fn.getcwd()

local function find_netrw_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      return win
    end
  end
  return -1
end

function M.open_sidebar(dir)
  local id = find_netrw_win()

  if id ~= -1 then
    vim.api.nvim_set_current_win(id)
  else
    vim.cmd("vertical botright split")
    local width = math.floor(vim.o.columns * 30 / 100)
    vim.cmd("vertical resize " .. width)
  end

  if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then
    vim.cmd("Explore " .. dir)
  else
    vim.cmd("Explore " .. vim.fn.getcwd())
  end

  vim.wo.winfixwidth = true
  vim.bo.buflisted = false
end

function M.close_sidebar()
  local id = find_netrw_win()
  if id ~= -1 then
    if #vim.api.nvim_list_wins() > 1 or #vim.api.nvim_list_tabpages() > 1 then
      vim.api.nvim_win_close(id, true)
    end
  end
end

function M.toggle()
  local id = find_netrw_win()
  if id ~= -1 then
    M.close_sidebar()
  else
    M.open_sidebar(netrw_last_dir)
  end
end

-- Track directory
vim.api.nvim_create_augroup("NetRWSidebarState", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "NetRWSidebarState",
  pattern = "netrw",
  callback = function()
    netrw_last_dir = vim.b.netrw_curdir or vim.fn.getcwd()
  end,
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = "NetRWSidebarState",
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "netrw" then
      netrw_last_dir = vim.b.netrw_curdir or vim.fn.getcwd()
    end
  end,
})

return M

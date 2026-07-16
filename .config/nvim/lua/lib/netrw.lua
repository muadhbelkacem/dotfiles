local M = {}

local netrw_last_dir = vim.fn.getcwd()

-- --- TRACK DIRECTORY SAFELY ---
local group = vim.api.nvim_create_augroup("NetRWState", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "netrw",
  callback = function()
    vim.opt_local.relativenumber = true
    netrw_last_dir = vim.b.netrw_curdir or vim.fn.getcwd()
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "netrw" then
      netrw_last_dir = vim.b.netrw_curdir or vim.fn.getcwd()
    end
  end,
})

-- --- FIND EXISTING NETRW WINDOW ---
local function find_netrw_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      return win
    end
  end
  return -1
end

-- --- TOGGLE ---
function M.toggle()
  local id = find_netrw_win()

  -- If netrw is already open
  if id ~= -1 then
    if vim.api.nvim_get_current_win() == id then
      -- If we are currently in the netrw window, toggle it off
      -- Try to return to the specific buffer we came from
      local prev = vim.w.netrw_prev_buf
      if prev and vim.api.nvim_buf_is_valid(prev) and vim.api.nvim_get_option_value("buflisted", { buf = prev }) and prev ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_set_current_buf(prev)
        -- Clean up the variable after returning
        vim.w.netrw_prev_buf = nil
      else
        local ok, _ = pcall(vim.cmd, "buffer #")
        if not ok then
          -- If no previous buffer, just open a new empty one
          vim.cmd("enew")
        end
      end
    else
      -- If netrw is open in another window, jump to it
      vim.api.nvim_set_current_win(id)
    end
    return
  end

  -- If netrw is not open, open it in the current window (fullscreen)
  -- Store current buffer to return to it later when toggling off
  vim.w.netrw_prev_buf = vim.api.nvim_get_current_buf()

  local dir = (netrw_last_dir ~= "" and vim.fn.isdirectory(netrw_last_dir) == 1) and netrw_last_dir or vim.fn.getcwd()
  vim.cmd("Explore " .. dir)
end

return M

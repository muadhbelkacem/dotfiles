local M = {}

function M.run(cmd, callback)
  cmd = cmd or "fzf"
  local temp = vim.fn.tempname()
  local shell_cmd = string.format("(%s) > %s", cmd, temp)
  local prev_win = vim.api.nvim_get_current_win()

  vim.cmd("botright 15new")
  local buf = vim.api.nvim_get_current_buf()

  vim.fn.termopen({ "sh", "-c", shell_cmd }, {
    on_exit = function(_, status)
      if vim.api.nvim_win_is_valid(prev_win) then
        vim.api.nvim_set_current_win(prev_win)
      end

      if status == 0 and vim.fn.filereadable(temp) == 1 then
        local lines = vim.fn.readfile(temp)

        if #lines > 0 then
          if callback then
            callback(lines)
          else
            for _, line in ipairs(lines) do
              if vim.fn.filereadable(line) == 1 or vim.fn.isdirectory(line) == 1 then
                vim.cmd("edit " .. vim.fn.fnameescape(line))
              end
            end
          end
        end
      end
      if vim.fn.filereadable(temp) == 1 then
        vim.fn.delete(temp)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })
  vim.cmd("startinsert")
end

local preview = vim.fn.executable("bat") == 1 and '--preview "bat --style=numbers --color=always --line-range :500 {}"'
  or ""

function M.files()
  M.run("fzf " .. preview)
end

function M.git_files()
  M.run("git ls-files | fzf " .. preview)
end

function M.buffers()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  local names = vim.tbl_map(function(b)
    return vim.api.nvim_buf_get_name(b)
  end, bufs)

  if #names == 0 then
    print("No buffers")
    return
  end

  local temp = vim.fn.tempname()
  vim.fn.writefile(names, temp)

  M.run("cat " .. temp .. " | fzf " .. preview, function(lines)
    for _, line in ipairs(lines) do
      vim.cmd("buffer " .. vim.fn.fnameescape(line))
    end
    if vim.fn.filereadable(temp) == 1 then
      vim.fn.delete(temp)
    end
  end)
end

return M

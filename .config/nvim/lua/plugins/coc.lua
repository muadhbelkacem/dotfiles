return {
  "neoclide/coc.nvim",
  branch = "release",
  init = function()
    -- Set global extensions as defined in vimrc
    vim.g.coc_global_extensions = {
      "coc-clangd",
      "coc-tsserver",
      "coc-eslint",
      "coc-json",
      "coc-prettier",
      "coc-rust-analyzer",
    }
  end,
  config = function()
    local keyset = vim.keymap.set
    -- Mappings from vimrc
    keyset("n", "<leader>d", "<Plug>(coc-definition)", { silent = true })
    keyset("n", "<leader>r", "<Plug>(coc-references)", { silent = true })
    -- Assuming one of the <leader>r was meant to be rename
    keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
    keyset("n", "<leader>f", "<Plug>(coc-format)", { silent = true })

    -- Show documentation in preview window
    function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
            vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
            vim.fn.CocActionAsync('doHover')
        else
            vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
    end
    keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })
  end
}

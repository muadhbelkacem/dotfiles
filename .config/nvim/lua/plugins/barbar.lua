return {
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    config = function()
      require("barbar").setup({
        -- Enable/disable animations
        animation = true,
        
        -- Enable/disable auto-hiding the tab bar when there is a single buffer
        auto_hide = true,
        
        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,
        
        -- Enables/disable clickable tabs
        clickable = true,
        
        -- Excludes buffers from the tabline
        exclude_ft = {'javascript', 'netrw'},
        exclude_name = {'package.json'},
        
        -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
        focus_on_close = 'left',
        
        -- Hide inactive buffers and file extensions.
        hide = {extensions = true, inactive = false},
        
        highlight_alternate = false,
        highlight_inactive_file_icons = false,
        highlight_visible = true,
        
        icons = {
          -- Disable buffer index and numbers globally
          buffer_index = false,
          buffer_number = false,
          button = '',
          gitsigns = {
            added = {enabled = true, icon = '+'},
            changed = {enabled = true, icon = '~'},
            deleted = {enabled = true, icon = '-'},
          },
          filetype = {
            custom_colors = false,
            enabled = true,
          },
          separator = {left = '▎', right = ''},
          separator_at_end = true,
          modified = {button = '●'},
          pinned = {button = '', filename = true},
          preset = 'default',
          
          -- Ensure numbers are disabled in all states
          alternate = {filetype = {enabled = false}, buffer_index = false},
          current = {buffer_index = false},
          inactive = {button = '×', buffer_index = false},
          visible = {modified = {buffer_number = false}, buffer_index = false},
        },
        
        insert_at_end = false,
        insert_at_start = false,
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        minimum_length = 0,
        semantic_letters = true,
        
        sidebar_filetypes = {
          netrw = {text = 'File Explorer', align = 'right'},
          undotree = {text = 'undotree', align = 'center'},
          ['neo-tree'] = {event = 'BufWipeout'},
          Outline = {event = 'BufWinLeave', text = 'symbols-outline', align = 'right'},
        },
        
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
        no_name_title = nil,
      })

      -- Key mappings for barbar
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      -- Move to previous/next
      map('n', '<leader>p', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<leader>n', '<Cmd>BufferNext<CR>', opts)
      
      -- Re-order to previous/next
      map('n', '<leader><', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<leader>>', '<Cmd>BufferMoveNext<CR>', opts)
      
      -- Goto buffer in position...
      map('n', '<C-0>', '<Cmd>BufferLast<CR>', opts)
      
      -- Close buffer
      map('n', '<leader>c', '<Cmd>BufferClose<CR>', opts)
      
      -- Sort automatically by...
      map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
      map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
      map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
      map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
    end,
  },
}

return
{
  'echasnovski/mini.surround',  
  version = '*',
  config = function()
    require('mini.surround').setup({
      mappings = {
        add = 'sa',          -- Add surrounding
        delete = 'sd',       -- Delete surrounding
        find = 'sf',         -- Find surrounding (to the right)
        find_left = 'sF',    -- Find surrounding (to the left)
        highlight = 'sh',    -- Highlight surrounding
        replace = 'sr',      -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
    
        -- Disable default 's' keybinding to avoid conflict
        suffix_last = '',
        suffix_next = '',
      },
    })
    end,
  }

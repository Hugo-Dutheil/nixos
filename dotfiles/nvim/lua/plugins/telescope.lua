    return {
      {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
          local builtin = require("telescope.builtin")
          vim.keymap.set('n', '<C-p>', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('v', '<leader>fg', function()
            local function slection()
              vim.cmd('normal! "vy')
              return vim.fn.getreg('v')
            end

            local selected_text = slection()
            builtin.grep_string({ default_text = selected_text })
          end, { noremap = true, silent = true } )
        end
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").setup({
            extensions = {
              ["ui-select"] = {
                require("telescope.themes").get_dropdown {}
              }
            }
          })
        require("telescope").load_extension("ui-select")
        end
      },
    }

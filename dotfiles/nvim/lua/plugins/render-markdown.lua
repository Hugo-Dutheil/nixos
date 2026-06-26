return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  opts = {
    -- This ensures it triggers even though the file extension is .ipynb
    -- since Jupytext forces the filetype to 'markdown'
    file_types = { "markdown" }, 
    latex = {
      enabled = true,
      -- This renders $...$ and $$...$$ as actual math
      converter = "latex2text", 
    },
    heading = {
      -- Makes headers look like bars/sections
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      -- Gives the code cells a distinct background color
      sign = false,
      width = "full",
      left_pad = 4,
      right_pad = 4,
    },
  },
}

return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
     filetypes = {
      "*", -- Highlight all files, but customize some exceptions below
      css = { css = true },
      html = { names = true }
    },
    user_default_options = {
      RGB = true,       -- #RGB hex codes
      RRGGBB = true,    -- #RRGGBB hex codes
      names = true,    -- "blue" or "red"
      RRGGBBAA = true,  -- #RRGGBBAA hex codes
      AARRGGBB = true, -- 0xAARRGGBB hex codes
      rgb_fn = true,    -- CSS rgb() and rgba() functions
      hsl_fn = true,    -- CSS hsl() and hsla() functions
      css = true,       -- Enable all CSS features: rgb_fn, hsl_fn, names, etc.
      css_fn = true,    -- Enable all CSS *functions*: rgb_fn, hsl_fn
      mode = "background", -- Set the display mode: background | foreground | virtualtext
    },
    -- Enable colorizer for these buffers using LSP or file detection
    buftypes = {},
  })

  -- Optionally, enable colorizer as soon as a buffer is opened
  vim.cmd("ColorizerAttachToBuffer")   require("colorizer").setup()
  end
}

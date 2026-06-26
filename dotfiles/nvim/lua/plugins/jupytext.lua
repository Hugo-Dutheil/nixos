return {
  "GCBallesteros/jupytext.nvim",
  lazy = false,
  config = function()
    require("jupytext").setup({
      style = "markdown",
      force_ft = "markdown",
      output_extension = "md", 
      custom_extension_map = {
        ipynb = "md",
      },
    })
  end,
}

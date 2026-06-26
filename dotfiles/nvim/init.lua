local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  ui = {
    border = "rounded",
  },
})

pcall(require, "vim-options")
pcall(require, "keybinds")

-- General Editor Settings
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Optional: Add a test command to check if your custom plugin is reachable
vim.api.nvim_create_user_command("CheckNotebook", function()
  local ok, nb = pcall(require, "prettyNotebook")
  if ok then
    print("prettyNotebook is reachable! isNotebook: " .. tostring(nb.isNotebook()))
  else
    print("prettyNotebook module NOT found in search path.")
  end
end, {})

vim.api.nvim_create_user_command("CreateSpace", function()
  local ok, nb = pcall(require, "prettyNotebook")
  if ok then
    nb.addSpacer(0, "Test\n")
  end
end, {})

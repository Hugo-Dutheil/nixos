vim.keymap.set('n', "<A-k>", "<Esc>:m .-2<CR>")

vim.cmd(":inoremap jk <Esc>")
vim.cmd("nmap OO O<Esc>j")
vim.keymap.set('n', "<A-j>", "<Esc>:m .+1<CR>")
vim.cmd("nmap oo o<Esc>k")
vim.cmd(":inoremap kj <Esc>")
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'g b', vim.lsp.buf.definition, {})
vim.keymap.set({'n'}, '<leader>ca', vim.lsp.buf.code_action, {})
-- Define a table of comment leaders based on file type
local comment_leaders = {
  c = "// ",
  cpp = "// ",
  java = "// ",
  sh = "# ",
  python = "# ",
  conf = "# ",
  tex = "% ",
  mail = "> ",
  vim = '" ',
  lua = '-- ',
  json = '// ',
  jsonc = '// ',
  yuck = ';;',
  css = '/**/',
  scss = '// ',
  qml = '// ',
  javascript = '// ',
  html = '<!---->',
  ino = '// ',
}

-- Function to get the correct comment leader for the current file type
function _G.get_comment_leader()
  return comment_leaders[vim.bo.filetype] or "# " -- Default to "#"
end

-- Function to comment/uncomment selected lines
function _G.comment_lines()
  local comment_leader = get_comment_leader()
  vim.cmd(string.format("silent '<,'>s/^/%s/", vim.fn.escape(comment_leader, "/")))
  vim.cmd("nohlsearch")
end

function _G.uncomment_lines()
  local comment_leader = get_comment_leader()
  vim.cmd(string.format("silent '<,'>s/^\\V%s//e", vim.fn.escape(comment_leader, "/")))
  vim.cmd("nohlsearch")
end

function _G.isCommented()
  local comment_leader = get_comment_leader()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  for line = start_line, end_line do
    local content = vim.fn.getline(line)
    -- If any line doesn't start with the leader → return false
    if not content:find("^" .. vim.pesc(comment_leader)) then
      return false
    end
  end

  return true
end

function _G.toggle_comment()
  local comment_leader = get_comment_leader()
  local esc = vim.pesc(comment_leader)

  local start_line = vim.fn.line("'<")
  local end_line   = vim.fn.line("'>")

  for lnum = start_line, end_line do
    local line = vim.fn.getline(lnum)

    if line:find("^" .. esc) then
      -- Uncomment this line
      local uncommented = line:gsub("^" .. esc, "")
      vim.fn.setline(lnum, uncommented)
    else
      -- Comment this line
      vim.fn.setline(lnum, comment_leader .. line)
    end
  end

  vim.cmd("nohlsearch")
end

-- Key mappings (Using Global Functions)
vim.api.nvim_set_keymap("v", ",cc", ":lua comment_lines()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ",cu", ":lua uncomment_lines()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ",ct", ":lua toggle_comment()<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap("v", "<TAB>", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-TAB>", "<gv", { noremap = true, silent = true })

-- Manage tabs
vim.api.nvim_set_keymap('n', "<leader>t", ":tabnew<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', "<A-l>", ":tabnext<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', "<A-h>", ":tabprev<CR>", { noremap = true, silent = false })


-- Manage splitpanes
vim.api.nvim_set_keymap('n', "<leader>sh", ":split<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', "<leader>sv", ":vsplit<CR>", { noremap = true, silent = false })
vim.keymap.set('n', "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set('n', "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set('n', "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set('n', "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Undo tree
vim.api.nvim_set_keymap('n', "<leader>u", ":UndotreeToggle<CR>", {noremap = true, silent = false})

--Molten
vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "evaluate visual selection" })

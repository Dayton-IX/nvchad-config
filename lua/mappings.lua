require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- nvimtree
map("n", "<Esc>", function()
  local api = require("nvim-tree.api")
   if api.tree.is_visible() then
    api.tree.close()
  else
    vim.cmd "noh"
  end
end, {desc = "Close nvim-tree"}
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

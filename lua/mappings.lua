require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>q", function()
  vim.diagnostic.setqflist({severity = {min = vim.diagnostic.severity.ERROR}})
end, { desc = "Open Diagnostics in QuickFix" })

map("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

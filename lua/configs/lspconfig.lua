-- Migrated to the nvim 0.11+ `vim.lsp.config` / `vim.lsp.enable` API.
-- See :help lspconfig-nvim-0.11

-- Load NvChad defaults (registers lua_ls + common on_attach/capabilities).
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

-- Shared options applied to every server (merged with per-server configs
-- that ship with nvim-lspconfig under lsp/<server>.lua).
vim.lsp.config("*", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Enable the servers you want. (Install them via :Mason or your package manager.)
vim.lsp.enable({
  "html",
  "cssls",
  "ts_ls",
  "tailwindcss",
})

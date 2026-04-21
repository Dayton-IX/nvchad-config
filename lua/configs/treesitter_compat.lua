-- Compatibility shim for nvim-treesitter (master branch) on Neovim 0.11+
-- In newer Neovim, `match[capture_id]` inside a query directive/predicate
-- is a list of TSNodes instead of a single TSNode. nvim-treesitter's master
-- branch hasn't been updated for this, so its custom directives crash with:
--   "attempt to call method 'range' (a nil value)"
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/8618
--
-- This re-registers the affected directives with the array unwrapped.

local M = {}

local function first_node(value)
  if value == nil then
    return nil
  end
  -- In nvim 0.11+ match[id] is TSNode[]; in older versions it's a TSNode.
  if type(value) == "table" then
    return value[#value] -- last node is the most recent/relevant match
  end
  return value
end

function M.apply()
  local query = vim.treesitter.query
  local opts = { force = true, all = true }

  -- HTML: <script type="..."> -> injection language
  local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
  }

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = first_node(match[pred[2]])
    if not node then
      return
    end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  -- Markdown fenced-code-block info string -> injection language.
  -- Delegate the alias lookup to nvim-treesitter's own helper so we stay
  -- in sync with its language alias table.
  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = first_node(match[pred[2]])
    if not node then
      return
    end
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    local lang = alias
    if ok and parsers and parsers.ft_to_lang then
      lang = parsers.ft_to_lang(alias) or alias
    end
    metadata["injection.language"] = lang
  end, opts)

  -- Lowercase the captured node's text (used by case-insensitive injections).
  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = first_node(match[id])
    if not node then
      return
    end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
      metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
  end, opts)
end

return M

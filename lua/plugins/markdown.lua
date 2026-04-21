-- Markdown viewing stack:
--   1. markview.nvim            -> pretty in-buffer render (toggle with <leader>mr)
--   2. image.nvim + diagram.nvim-> inline mermaid/plantuml/d2 via Ghostty's kitty graphics protocol
--   3. markdown-preview.nvim    -> browser preview as a backup (toggle with <leader>mp)
--
-- External deps you must install once:
--   pnpm add -g @mermaid-js/mermaid-cli      # provides `mmdc` for diagram.nvim
--   sudo apt install imagemagick             # or pacman/brew, for image.nvim (`magick` / `convert`)

return {
  -- Image rendering backend (kitty graphics protocol -> works great in Ghostty).
  -- Uses the `magick_cli` processor so we don't need luarocks / the magick lua rock.
  {
    "3rd/image.nvim",
    build = false, -- explicitly skip any rock build step
    ft = { "markdown", "md", "rmd", "quarto", "norg" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "quarto", "rmd" },
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
    },
  },

  -- Mermaid / PlantUML / D2 / Gnuplot code-blocks -> PNG -> image.nvim
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown", "md", "rmd", "quarto", "norg" },
    opts = function()
      return {
      integrations = {
        require("diagram.integrations.markdown"),
      },
      renderer_options = {
        mermaid = {
          theme = "dark",
          background = "transparent",
          scale = 2,
        },
        plantuml = { charset = "utf-8" },
        d2 = { theme_id = 1 },
        gnuplot = { theme = "dark", size = "800,600" },
      },
      }
    end,
  },

  -- Pretty in-buffer markdown rendering (the main "view mode")
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- plugin is already internally lazy; docs say do NOT lazy-load it
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        enable = true, -- auto-render on open
        filetypes = { "markdown", "md", "rmd", "quarto", "typst", "html" },
        ignore_buftypes = { "nofile" },
        -- hybrid_modes shows raw syntax only on the cursor line while the rest
        -- stays rendered. Toggle per-session with :Markview HybridToggle.
        hybrid_modes = { "n", "i" },
        linewise_hybrid_mode = true,
      },
    },
    keys = {
      { "<leader>mr", "<cmd>Markview Toggle<cr>",       desc = "Markdown: toggle render (markview)" },
      { "<leader>mh", "<cmd>Markview HybridToggle<cr>", desc = "Markdown: toggle hybrid mode" },
    },
  },

  -- Browser preview (mermaid, katex, plantuml etc. all work natively)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && pnpm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown: toggle browser preview" },
    },
  },
}

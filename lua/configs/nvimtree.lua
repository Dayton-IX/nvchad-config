local options = {
  filters = {
    dotfiles = false,
    git_ignored = false,
    custom = { "node_modules", ".git" },
  },

  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },

  view = {
    centralize_selection = false,
    cursorline = true,
    debounce_delay = 15,
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = math.floor(vim.o.columns * 0.5), -- 50% screen
        height = math.floor(vim.o.lines * 0.7), -- 70% screen
        col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.5)) / 2),
        row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.7)) / 2),
      },
    },

  },

  git = {
    enable = true,
    ignore = true,
  },

  filesystem_watchers = {
    enable = true,
  },

  actions = {
    open_file = {
      resize_window = true,
    },
  },

  renderer = {
    root_folder_label = false,
    highlight_git = true,
    highlight_opened_files = "none",

    indent_markers = {
      enable = true,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      glyphs = {
        default = "󰈚",
        symlink = "󰌂",
        folder = {
          default = "󰉋",
          empty = "󰉖",
          empty_open = "󰷏",
          open = "󰝰",
          symlink = "󰉒",
          symlink_open = "󰉒",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "",
          untracked = "",
          deleted = "",
          ignored = "",
        },
      },
    },
  },
}

return options

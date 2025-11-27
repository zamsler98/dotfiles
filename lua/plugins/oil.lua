return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,      -- Replace netrw
    delete_to_trash = true,            -- Move to trash instead of permanent delete

    view_options = {
      show_hidden = true,              -- Show dotfiles
    },

    keymaps = {
      ["<CR>"] = "actions.select",                -- Open file / enter directory
      ["<BS>"] = "actions.parent",                -- Go up directory
      ["-"] = "actions.open_cwd",                 -- Open current working dir
      ["_"] = "actions.open_cwd",                 -- Same as mini.files
      ["<C-r>"] = "actions.refresh",              -- Refresh
      ["<C-s>"] = "actions.select_split",         -- Open in split
      ["<C-v>"] = "actions.select_vsplit",        -- Open in vsplit
      ["<C-t>"] = "actions.select_tab",           -- Open in new tab
      ["q"] = "actions.close",                    -- Quit oil
    },

    float = {
      padding = 2,
      max_width = 60,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    preview = {
      border = "rounded",
    },
  },

  dependencies = { "nvim-tree/nvim-web-devicons" },

  keys = {
    { "<leader>oo", function() require("oil").open_float() end, desc = "Open Oil (float)" },
  },
} 

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",

  opts = {
    open_for_directories = true,  -- Open Yazi in the current dir automatically

    keymaps = {
      show_help = "g?",           -- Show Yazi help
      open_file = "<CR>",         -- Open selected file
      vertical_split = "<C-v>",   -- Open file in VSPLIT
      horizontal_split = "<C-s>", -- Open file in SPLIT
      new_tab = "<C-t>",          -- Open in new tab
      quit = "q",                 -- Quit Yazi
    },

    floating_window_scaling_factor = 0.9,  -- Nice floating window size
    yazi_floating_window_winblend = 0,     -- No transparency
  },

  keys = {
    -- Open Yazi in the current directory
    { "-", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    { "<leader>yh", "<cmd>Yazi cwd<cr>", desc = "Open Yazi" },
  },
}

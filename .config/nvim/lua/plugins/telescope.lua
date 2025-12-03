return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.1.9",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        path_display = { "smart" },
      },
      pickers = {
        find_files = { hidden = true },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
    telescope.load_extension("fzf")
  end,
} 

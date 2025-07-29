return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      update_cwd = true,
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      renderer = {
        group_empty = true,
      },
    }
  end,
}

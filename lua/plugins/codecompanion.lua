return {
  "olimorris/codecompanion.nvim",
  opts = {
    adapters = {
      opts = {
        allow_insecure = true, -- or false, as needed
      }
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
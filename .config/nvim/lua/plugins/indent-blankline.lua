return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
    },
    exclude = {
      filetypes = {
        "help", "terminal", "lazy", "lspinfo", "Trouble",
        "mason", "NvimTree", "dashboard",
      },
    },
  },
}

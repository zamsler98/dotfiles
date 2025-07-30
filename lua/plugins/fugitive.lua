return {
  "tpope/vim-fugitive",
  event = "VeryLazy",
  config = function()
    -- Optional: Keymaps for common Fugitive commands
    vim.keymap.set('n', '<leader>gs', ":Git<CR>", { desc = "Fugitive: Git status" })
    vim.keymap.set('n', '<leader>gd', ":Gdiffsplit<CR>", { desc = "Fugitive: Git diff split" })
    vim.keymap.set('n', '<leader>gb', ":Git blame<CR>", { desc = "Fugitive: Git blame" })
  end
}

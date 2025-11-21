return {
    "github/copilot.vim",
    config = function()
        -- Recommended settings
        vim.g.copilot_no_tab_map = true     -- Don't use Tab automatically
        vim.g.copilot_assume_mapped = true  -- Avoid keymap conflicts

        -- Keymap for accepting Copilot suggestion
        vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', {
            silent = true,
            expr = true,
            replace_keycodes = false,
        })

        -- Optional: trigger Copilot panel
        vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = "Copilot Panel" })
    end,
}

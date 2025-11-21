return {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-treesitter" },
    config = function()
        require("codecompanion").setup({
            -- You can explicitly set adapters, but Copilot is default
            strategies = {
                chat = { adapter = "copilot" },
                inline = { adapter = "copilot" },
            },
            -- Optionally configure display, logging, etc.
            display = {
                chat = { border = "rounded" },
            },
        })
    end
}

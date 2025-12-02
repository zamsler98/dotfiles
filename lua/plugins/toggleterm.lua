return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        -- Basic setup
        require("toggleterm").setup({
            size = 15,
            open_mapping = [[<C-\>]],
            shading_factor = 2,
            direction = "horizontal", -- default
            float_opts = { border = "curved" },
        })

        --------------------------------------------------------------------
        -- Create a persistent terminal we can toggle between directions
        --------------------------------------------------------------------
        local Terminal = require("toggleterm.terminal").Terminal
        local main_term = Terminal:new({
            direction = "horizontal",
            close_on_exit = false,
            hidden = true,
        })

        --------------------------------------------------------------------
        -- Keymaps for toggling
        --------------------------------------------------------------------
        -- Toggle terminal in split mode
        vim.keymap.set("n", "<leader>ts", function()
            main_term.direction = "horizontal"
            main_term:toggle()
        end, { desc = "Toggle Terminal Split" })

        -- Toggle terminal in floating mode
        vim.keymap.set("n", "<leader>tf", function()
            main_term.direction = "float"
            main_term:toggle()
        end, { desc = "Toggle Terminal Float" })

        -- Optional: ESC closes terminal and returns to normal mode
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        end
        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
}

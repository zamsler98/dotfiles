return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local toggleterm = require("toggleterm")
        toggleterm.setup({
            size = function(term)
                if term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.35)
                else
                    return 15
                end
            end,
            open_mapping = [[<C-\>]],
            shading_factor = 2,
            direction = "vertical",
            close_on_exit = true,
            float_opts = {
                border = "curved",
                width = function()
                    return math.floor(vim.o.columns * 0.95)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.85)
                end,
            },
        })

        local Terminal = require("toggleterm.terminal").Terminal

        -- Persistent terminal instance
        local main_term = Terminal:new({ hidden = true, close_on_exit = true })

        -- Function to toggle terminal with a direction
        local function toggle_term(direction)
            main_term.direction = direction
            main_term:toggle()
        end

        -- Helper to enter insert mode if terminal is open
        local function enter_insert_if_open(term)
            vim.defer_fn(function()
                if term:is_open() then
                    vim.cmd("startinsert")
                end
            end, 20)
        end

        -- Keymap to toggle main terminal and enter insert mode only when opening
        vim.keymap.set("n", "<C-n>", function()
            main_term:toggle()
            enter_insert_if_open(main_term)
        end, { desc = "Toggle main terminal", noremap = true, silent = true })

        -- Terminal mode: <C-n> closes the terminal
        vim.keymap.set("t", "<C-n>", [[<C-\><C-n>:q<CR>]], { noremap = true, silent = true, desc = "Close Terminal" })

        -- Keymaps to switch terminal modes
        vim.keymap.set("n", "<leader>os", function()
            toggle_term("vertical")  -- split
            enter_insert_if_open(main_term)
        end, { desc = "Toggle Terminal Split" })

        vim.keymap.set("n", "<leader>of", function()
            toggle_term("float")  -- floating
            enter_insert_if_open(main_term)
        end, { desc = "Toggle Terminal Float" })

        -- Terminal keymaps
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            -- Make <esc> only exit terminal insert mode (don't close)
            vim.keymap.set("t", "<esc>", [[<C-\\><C-n>]], opts)
            -- Map <C-q> to close the terminal
            vim.keymap.set("t", "<C-q>", [[<C-\\><C-n>:q<CR>]], opts)
            vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
            vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
            vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
            vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        -- Auto-enter insert mode reliably when entering any terminal buffer
        local augroup_term_insert = vim.api.nvim_create_augroup("Term-Insert", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "TermOpen", "TermEnter" }, {
            group = augroup_term_insert,
            pattern = "term://*",
            callback = function()
                vim.defer_fn(function() vim.cmd("startinsert") end, 20)
            end
        })
    end,
}

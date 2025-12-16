return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() 
        require('lualine').setup({
            options = {
                icons_enabled = true,              -- Enables filetype icons / separators (requires NerdFonts)
                theme = 'auto',                    -- Auto-adjust theme to current colorscheme
                component_separators = { left = '', right = '' },
                section_separators   = { left = '', right = '' },
                disabled_filetypes = {             -- Filetypes where lualine is hidden
                    statusline = {},
                    winbar = {},
                },
                always_divide_middle = true,
                globalstatus = true,               -- Single statusline for all splits (Neovim 0.7+)
                refresh = {
                    statusline = 1000,               -- Update frequencies (ms)
                    tabline = 1000,
                    winbar = 1000,
                },
            },

            sections = {
                lualine_a = { 'mode' },                                -- Current Vim mode (NORMAL / INSERT / etc.)
                lualine_b = { 'branch', 'diff', 'diagnostics' },       -- Git + diagnostics
                lualine_c = { { 'filename', path = 1, shorting_target = 50 } },                            -- Current file path/name (relative, shorting target 50)
                lualine_x = { 'encoding', 'fileformat', 'filetype' },  -- UTF-8, Unix, Lua, etc.
                lualine_y = { 'progress' },                            -- Shows percentage through file
                lualine_z = { 'location' },                            -- Line/column
            },

            inactive_sections = { -- Shown when the window is not focused
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1, shorting_target = 50 } },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },

            tabline = {},      -- You can add a tabline here if desired
            winbar = {},       -- And a winbar (Neovim 0.8+)
            inactive_winbar = {}
        })
    end
}

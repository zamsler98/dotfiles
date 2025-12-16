return {
    "Saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        require("blink.cmp").setup({
            keymap = {
                preset = "default", -- standard mappings
                -- Removed default <CR> accept mapping to preserve newline behavior
                ['<CR>'] = { "accept", "fallback"} ,
                ['<C-k>'] = { "select_prev"},
                ['<C-j>'] = { "select_next"},
            },
            completion = {
                menu = {
                    border = "rounded",
                },
                documentation = {
                    window = {
                        border = "rounded",
                    },
                },
            },
            signature = {
                window = {
                    border = "rounded",
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        })
    end
}

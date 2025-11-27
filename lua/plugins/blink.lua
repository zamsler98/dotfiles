return {
    "Saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        require("blink.cmp").setup({
            keymap = {
                preset = "default", -- standard mappings
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

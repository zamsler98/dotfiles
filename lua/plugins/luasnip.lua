return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp", -- optional: enables regex snippets
    dependencies = {
        "rafamadriz/friendly-snippets", -- optional
    },
    config = function()
        require("luasnip").setup({
            history = true,
            updateevents = "TextChanged,TextChangedI",
        })

        -- Load VSCode-style snippets
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
}

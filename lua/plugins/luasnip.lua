return {
  -- Load LuaSnip with friendly-snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      -- Friendly prebuilt snippets
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")

      -- Load VSCode-style snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- OPTIONAL: Load your own snippets from Lua files
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" }
      })

      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      -- Keymaps for snippet navigation
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then ls.expand_or_jump() end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, { silent = true })

      vim.keymap.set("i", "<C-l>", function()
        if ls.choice_active() then ls.change_choice(1) end
      end, { silent = true })
    end,
  },
}

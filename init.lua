vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = "101"

-- Use spaces instead of tabs, set tab width to 4
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 4        -- Size of an indent
vim.opt.tabstop = 4           -- Number of spaces tabs count for
vim.opt.softtabstop = 4       -- Number of spaces for editing operations
vim.opt.smartindent = true

-- Line wrapping options
vim.opt.wrap = true           -- Enable line wrapping
vim.opt.linebreak = true      -- Wrap at convenient points (not in the middle of words)
vim.opt.showbreak = "↪ "      -- Show this symbol at the start of wrapped lines
vim.opt.breakindent = true    -- Indent wrapped lines to match line start




-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup("plugins")

vim.cmd.colorscheme "catppuccin-macchiato"

require("keymaps")

local harpoon = require('harpoon')
harpoon:setup({})

vim.lsp.config("roslyn_ls", {
  on_attach = function() 
    print("Roslyn connected")
  end,
    cmd = {
        "dotnet",
        (vim.fn.expand("~") .. "/lsps/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll"),
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
    },
    -- Add other options here
})


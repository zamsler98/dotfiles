vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
--vim.opt.colorcolumn = "101"

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

vim.opt.cursorline = true

require("config.lazy")
require("config.keymaps")

vim.cmd("colorscheme gruvbox")

vim.lsp.enable('roslyn_ls')

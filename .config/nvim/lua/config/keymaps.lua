local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true })

vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- Move between splits with Ctrl+h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to below split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to above split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right split' })

-- Save file with Ctrl+S in normal mode
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, desc = 'Save file' })

-- Save file with Ctrl+S in insert mode and return to normal mode
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, desc = 'Save file and return to normal mode' })

-- Toggle relative line numbers
vim.keymap.set('n', '<leader>ur', function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = 'Toggle relative line numbers' })

-- Split management
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, desc = 'Vertical split' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>q', ':close<CR>', { noremap = true, desc = 'Close split' })

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Go to references' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover' })
vim.keymap.set('n', 'gh', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Hover definition' }) 
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })

-- Clipboard copy keymaps
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'Copy selection to clipboard' })
vim.keymap.set('n', '<leader>Y', '"+yg_', { noremap = true, desc = 'Copy to clipboard to end of line' })
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, desc = 'Copy to clipboard' })
vim.keymap.set('n', '<leader>yy', '"+yy', { noremap = true, desc = 'Copy line to clipboard' })

-- Clipboard paste keymaps
vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, desc = 'Paste from clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { noremap = true, desc = 'Paste before from clipboard' })
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, desc = 'Paste from clipboard' })
vim.keymap.set('v', '<leader>P', '"+P', { noremap = true, desc = 'Paste before from clipboard' })

vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>t", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>cn", "<cmd>CodeCompanionChat<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, '<leader>cs', function()
  require("codecompanion").toggle({
    window_opts = {
      layout = "vertical",
    }
  })
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, '<leader>cf', function()
  require("codecompanion").toggle({
    window_opts = {
      layout = "float",
      width = 0.8,
    }
  })
end, { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

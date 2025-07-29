vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Telescope Live Grep' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Telescope Buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Telescope Help Tags' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Telescope Recent Files' })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').commands, { desc = 'Telescope Commands' })
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').marks, { desc = 'Telescope Marks' })
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = 'Telescope Keymaps' })

-- Indent line right/left in normal mode
vim.keymap.set('n', '<Tab>', '>>', { noremap = true, desc = 'Indent line right' })
vim.keymap.set('n', '<S-Tab>', '<<', { noremap = true, desc = 'Indent line left' })

-- Indent selection right/left in visual mode and keep selection
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, desc = 'Indent selection right and keep selection' })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, desc = 'Indent selection left and keep selection' })

-- Save file with Ctrl+S in normal mode
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, desc = 'Save file' })

-- Save file with Ctrl+S in insert mode and return to normal mode
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, desc = 'Save file and return to normal mode' })

-- Remap capital Y to yank to end of line
vim.keymap.set('n', 'Y', 'y$', { noremap = true, desc = 'Yank to end of line' })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to below window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to above window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { noremap = true, desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { noremap = true, desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { noremap = true, desc = 'Delete buffer' })

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
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { buffer = bufnr, desc = 'Format' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = bufnr, desc = 'Show diagnostics' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = bufnr, desc = 'Diagnostics to loclist' })

-- Copy Paste
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, desc = 'Copy selection to clipboard' })
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, desc = 'Cut selection to clipboard' })
vim.keymap.set('n', '<C-v>', '"+p', { noremap = true, desc = 'Paste from clipboard' })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, desc = 'Paste from clipboard in insert mode' })

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

-- Quickfix list keymaps
vim.keymap.set('n', '<leader>qf', ':copen<CR>', { noremap = true, desc = 'Open quickfix list' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { noremap = true, desc = 'Close quickfix list' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { noremap = true, desc = 'Next quickfix item' })
vim.keymap.set('n', '<leader>qp', ':cprev<CR>', { noremap = true, desc = 'Previous quickfix item' })

-- Comment line/selection with Ctrl+/
vim.keymap.set('n', '<C-/>', 'gcc', { noremap = false, desc = 'Toggle comment line' })
vim.keymap.set('v', '<C-/>', 'gc', { noremap = false, desc = 'Toggle comment selection' })

-- Toggle file tree view
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, desc = 'Toggle file tree' })
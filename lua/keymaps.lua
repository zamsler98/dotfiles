vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Telescope Live Grep' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Telescope Find Files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Telescope Buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Telescope Help Tags' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Telescope Recent Files' })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').commands, { desc = 'Telescope Commands' })
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').marks, { desc = 'Telescope Marks' })
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = 'Telescope Keymaps' })

-- Load the module
local search_dir = require("custom.search_dir")

-- Set user command
vim.api.nvim_create_user_command("SearchDir", search_dir.set_dir, {})

-- Keymap to grep in the selected dir
vim.keymap.set("n", "<leader>fe", search_dir.grep_in_dir, {
    desc = "Live Grep in Selected Directory",
})

vim.keymap.set("n", "<leader>fd", function()
    require("telescope.builtin").find_files({
        cwd = require("custom.search_dir").search_dir,
        prompt_title = "Find Files in " .. require("custom.search_dir").search_dir,
    })
end, { desc = "Find Files in Selected Directory" })


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

-- Toggle relative line numbers
vim.keymap.set('n', '<leader>ur', function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = 'Toggle relative line numbers' })
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

-- Switch buffers in splits
vim.keymap.set('n', '<leader>bs', '<C-w>w:bnext<CR>', { noremap = true, desc = 'Switch buffers in splits' })

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
vim.keymap.set('n', 'gh', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Hover definition' }) 
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
vim.keymap.set('n', 'gh', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Hover definition' }) 
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })

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
vim.keymap.set('n', 'gh', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Hover definition' }) 
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

-- Tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { noremap = true, desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { noremap = true, desc = 'Close tab' })

-- Harpoon
local harpoon = require('harpoon')
-- basic telescope configuration
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--     local file_paths = {}
--     for _, item in ipairs(harpoon_files.items) do
--         table.insert(file_paths, item.value)
--     end

--     require("telescope.pickers").new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--             results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--     }):find()
-- end
-- vim.keymap.set('n', '<leader>hl', function() toggle_telescope(harpoon:list()) end, { desc = 'Harpoon: List marks' })

local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
vim.keymap.set('n', '<leader>hl', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: List marks' })
vim.keymap.set('n', '<leader>hx', function() harpoon:list():add() end, { desc = 'Harpoon: Mark file' })
vim.keymap.set('n', '<leader>hn', function() harpoon:list():next() end, { desc = 'Harpoon: Next file' })
vim.keymap.set('n', '<leader>hp', function() harpoon:list():prev() end, { desc = 'Harpoon: Previous file' })

local harpoon = require('harpoon')
harpoon:extend({
  UI_CREATE = function(cx)
    for i = 1, 9 do
      vim.keymap.set("n", tostring(i), function()
        harpoon.ui:select_menu_item({index = i})
      end, { buffer = cx.bufnr, desc = "Harpoon: Go to file " .. i })
    end

    vim.keymap.set("n", "<leader>hv", function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<leader>hs", function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<leader>ht", function()
      harpoon.ui:select_menu_item({ tabedit = true })
    end, { buffer = cx.bufnr })
  end,
})


-- Code Companion
vim.keymap.set({'n', 'v'}, '<leader>aa', '<cmd>CodeCompanionActions<CR>', {noremap = true, desc = "CodeCompanion Actions"})
vim.keymap.set({'n', 'v'}, '<leader>ct', '<cmd>CodeCompanionChat Toggle<CR>', {noremap = true, desc = "CodeCompanion Chat Toggle"})
vim.keymap.set('v', '<leader>cp', '<cmd>CodeCompanionChat Add<CR>', {noremap = true, desc = "CodeCompanion add to Chat"})
vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat<CR>', { noremap = true, desc = 'CodeCompanion Chat (Floating)' })
vim.keymap.set('n', '<leader>ca', function() 
    require("codecompanion").prompt("agent")
end, { noremap = true, silent = true})
vim.keymap.set({'v'}, '<leader>cd', '<cmd>CodeCompanion /func_doc<CR>', {noremap = true, desc = "CodeCompanion document function"})

-- CodeCompanion Inline Prompt
vim.keymap.set({'n', 'v'}, '<leader>ci', ':CodeCompanion ', { noremap = true, desc = 'CodeCompanion Inline Prompt' })


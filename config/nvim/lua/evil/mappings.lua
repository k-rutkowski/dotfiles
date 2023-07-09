-- [[ Keymaps ]]
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- basic
vim.keymap.set({ 'n', 'v' }, ';', ":", { noremap = true })
vim.keymap.set({ 'n', 'v' }, '\\', ";", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '\'', "`", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'g\'', "g`", { noremap = true, silent = true })
vim.keymap.set('n', 'go', "o<Esc>k", { silent = true })
vim.keymap.set('n', 'gO', "O<Esc>j", { silent = true })
vim.keymap.set('i', 'jk', "<Esc>", { noremap = true, silent = true })

-- increment/decrement a number
vim.keymap.set('n', '=', '<C-a>', { silent = true })
vim.keymap.set('n', '-', '<C-x>', { silent = true })
vim.keymap.set('v', '=', '<C-a>gv', { silent = true })
vim.keymap.set('v', '-', '<C-x>gv', { silent = true })
vim.keymap.set('v', '+', 'g<C-a>gv', { noremap = true, silent = true })
vim.keymap.set('v', '_', 'g<C-x>gv', { noremap = true, silent = true })

-- window management
vim.keymap.set('n', '|', "<cmd>vsplit<cr>")
vim.keymap.set('n', '_', "<cmd>split<cr>")
--vim.keymap.set('n', '<a-h>', 'function() require("smart-splits").move_cursor_left() end', { expr = true, silent = true })
--vim.keymap.set('n', '<a-j>', 'function() require("smart-splits").move_cursor_down() end', { expr = true, silent = true })
--vim.keymap.set('n', '<a-k>', 'function() require("smart-splits").move_cursor_up() end', { expr = true, silent = true })
--vim.keymap.set('n', '<a-l>', 'function() require("smart-splits").move_cursor_right() end', { expr = true, silent = true })
-- ["<up>"] = { function() require("smart-splits").resize_up(2) end, desc = "Resize split up" },
-- ["<down>"] = { function() require("smart-splits").resize_down(2) end, desc = "Resize split down" },
-- ["<left>"] = { function() require("smart-splits").resize_left(2) end, desc = "Resize split left" },
-- ["<right>"] = { function() require("smart-splits").resize_right(2) end, desc = "Resize split right" },

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

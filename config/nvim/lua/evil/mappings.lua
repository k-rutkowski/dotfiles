-- [[ Keymaps ]]
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- dealing with word wrap
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- basic
vim.keymap.set('i', 'jk', "<Esc>", { noremap = true, silent = true })
vim.keymap.set('n', '\\', ";", { noremap = true, silent = true })
vim.keymap.set('n', ';', ":", { noremap = true })
vim.keymap.set('n', '\'', "`", { noremap = true, silent = true })
vim.keymap.set('n', 'g\'', "g`", { noremap = true, silent = true })
vim.keymap.set('n', 'go', "o<Esc>k", { silent = true })
vim.keymap.set('n', 'gO', "O<Esc>j", { silent = true })

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


-- See `:help vim.keymap.set()`

vim.keymap.set('n', '<leader>e', '<cmd>Ex<cr><cmd>set number<cr><cmd>set relativenumber<cr>', { silent = true, desc = "Explore project directory" })

-- basic
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, ';', ":", { noremap = true })
vim.keymap.set({ 'n', 'v' }, ',', ";", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '\\', ",", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '\'', "`", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'g\'', "g`", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<C-p>', '<C-d>zz', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'n', 'nzzzv', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'N', 'Nzzzv', { noremap = true })
vim.keymap.set('n', 'go', 'o<Esc>k', { noremap = true, silent = true })
vim.keymap.set('n', 'gO', 'O<Esc>j', { noremap = true, silent = true })
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'g=', '=', { noremap = true, silent = true })
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- yank / paste
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], { noremap = true })
vim.keymap.set('n', '<leader>Y', [["+Y]], { noremap = true })
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]], { noremap = true })
vim.keymap.set('x', '<leader>p', [["_dP]], { noremap = true })

-- text operations
vim.keymap.set('v', '<leader>s', '"by:%s/<C-r>b//gI<left><left><left>', { noremap = true, desc = 'Substitute all occurences of highlighted text' })
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<left><left><left>]], { noremap = true, desc = 'Substitute all occurences of a word under cursor' })

-- quick / location list  navigation
vim.keymap.set('n', '<C-S-k>', '<cmd>cnext<cr>zz', { noremap = true })
vim.keymap.set('n', '<C-S-j>', '<cmd>cprev<cr>zz', { noremap = true })
vim.keymap.set('n', '<leader>k', '<cmd>lnext<cr>zz', { noremap = true })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<cr>zz', { noremap = true })

-- tmux integration
vim.keymap.set('n', '<C-s>', '<cmd>!tmux neww tmux-sessionizer.sh<cr>', { noremap = true, silent = true })

-- increment/decrement a number
vim.keymap.set('n', '=', '<C-a>', { silent = true })
vim.keymap.set('n', '-', '<C-x>', { silent = true })
vim.keymap.set('v', '=', '<C-a>gv', { silent = true })
vim.keymap.set('v', '-', '<C-x>gv', { silent = true })
vim.keymap.set('v', '+', 'g<C-a>gv', { noremap = true, silent = true })
vim.keymap.set('v', '_', 'g<C-x>gv', { noremap = true, silent = true })

-- buffer management
vim.keymap.set('n', '<leader>c', vim.cmd.bdelete, { desc = "Close current buffer" })

-- window management
vim.keymap.set('n', '<leader>\\', '<cmd>vsplit<cr>', { noremap = true })
vim.keymap.set('n', '<leader>-', '<cmd>split<cr>', { noremap = true })
vim.keymap.set('n', '<leader>x', '<C-w>q', { noremap = true })
--vim.keymap.set('n', '<up>', '<C-w>k', { noremap = true })
--vim.keymap.set('n', '<down>', '<C-w>j', { noremap = true })
--vim.keymap.set('n', '<left>', '<C-w>h', { noremap = true })
--vim.keymap.set('n', '<right>', '<C-w>l', { noremap = true })
vim.keymap.set('n', '<up>', '<C-w>+<C-w>+', { noremap = true })
vim.keymap.set('n', '<down>', '<C-w>-<C-w>-', { noremap = true })
vim.keymap.set('n', '<left>', '<C-w><<C-w><', { noremap = true })
vim.keymap.set('n', '<right>', '<C-w>><C-w>>', { noremap = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Misc
vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<cr>', { desc = 'Make this file executable' })
vim.keymap.set('n', '<leader>rc', '<cmd>edit ~/.config/nvim/lua/evil<cr>', { desc = 'Open neovim config' })

-- Copilot
vim.api.nvim_set_keymap("i", "<C-i>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Previous()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Next()', { silent = true, expr = true })
vim.cmd("let g:copilot_no_tab_map = v:true")


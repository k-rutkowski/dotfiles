return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  config = function()
    vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { noremap = true, desc = 'Window left' })
    vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { noremap = true, desc = 'Window down' })
    vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { noremap = true, desc = 'Window up' })
    vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { noremap = true, desc = 'Window right' })
  end
}

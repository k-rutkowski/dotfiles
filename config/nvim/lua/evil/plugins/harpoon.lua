return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local mark = require('harpoon.mark')
    local ui = require('harpoon.ui')

    vim.keymap.set('n', '<leader>m', mark.add_file, { desc = 'Harpoon: Mark file' })
    vim.keymap.set('n', '<leader>h', ui.toggle_quick_menu, { desc = 'Harpoon: Menu' })
    vim.keymap.set('n', 'H', ui.nav_prev, { noremap = true, desc = 'Harpoon: Previous file' })
    vim.keymap.set('n', 'L', ui.nav_next, { noremap = true, desc = 'Harpoon: Next file' })
    vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'Harpoon: File 1' })
    vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'Harpoon: File 2' })
    vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'Harpoon: File 3' })
    vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'Harpoon: File 4' })
  end
}

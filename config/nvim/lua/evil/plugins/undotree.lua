return {
  'mbbill/undotree',
  config = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { noremap = true, desc = 'Undo tree' })
  end
}

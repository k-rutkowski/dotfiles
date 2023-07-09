local function show_documentation()
  local filetype = vim.bo.filetype
  local crates = require('crates')
  if vim.tbl_contains({ 'vim', 'help' }, filetype) then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  elseif vim.tbl_contains({ 'man' }, filetype) then
    vim.cmd('Man ' .. vim.fn.expand('<cword>'))
  elseif vim.fn.expand('%:t') == 'Cargo.toml' and crates.popup_available() then
    crates.show_popup()
  else
    vim.lsp.buf.hover()
  end
end

return {
  'saecki/crates.nvim',
  tag = 'v0.3.0',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('crates').setup()
    vim.keymap.set('n', 'K', show_documentation, { noremap = true, silent = true, desc = 'Hover Documentation' })
  end
}

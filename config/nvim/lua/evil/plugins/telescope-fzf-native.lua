-- Fuzzy Finder Algorithm which requires local dependencies to be built.
-- Only load if `make` is available. Make sure you have the system
-- requirements installed.

return {
  'nvim-telescope/telescope-fzf-native.nvim',
  -- NOTE: If you are having trouble with this installation,
  --       refer to the README for telescope-fzf-native for more instructions.
  build = 'make',
  cond = function()
    return vim.fn.executable 'make' == 1
  end,
  config = function()
    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
  end
}

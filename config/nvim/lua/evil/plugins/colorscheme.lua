local function make_transparent()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
  --vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })
  --vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'none' })
end

return {
  {
    'tiagovla/tokyodark.nvim',
    tokyodark_transparent_background = true,
  },
  {
    'navarasu/onedark.nvim',
    style = 'darker',
    transparent = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('onedark')
      make_transparent()
    end,
  },
}

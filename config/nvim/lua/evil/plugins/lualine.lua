local function show_macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  else
    return "recording @" .. reg
  end
end

return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
  	icons_enabled = true,
  	theme = 'onedark',
  	component_separators = '·',
  	--section_separators = '',
    },
    sections = {
  	lualine_x = { show_macro_recording },
  	lualine_y = { 'encoding', 'fileformat', 'filetype' },
  	lualine_z = { 'location', 'progress' },
    },
  },
}


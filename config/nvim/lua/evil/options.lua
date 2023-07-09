-- [[ Options ]]
-- See `:help vim.o`

vim.o.termguicolors = true
vim.o.lazyredraw = false
vim.o.mouse = ''
vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true
vim.o.cmdheight = 0

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 250

vim.wo.signcolumn = 'yes'
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 4

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.scrolloff = 2

vim.o.conceallevel = 2
vim.o.foldenable = true
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.o.breakindent = true
vim.o.linebreak = true
vim.o.showbreak = "↪ "
vim.o.listchars = "tab:│→,extends:⟩,precedes:⟨,trail:·,nbsp:␣"
vim.o.list = false

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.expandtab = false
vim.o.spell = false
vim.o.completeopt = 'menuone,noselect'

vim.o.nrformats = "bin,hex,alpha"


-- [[ Options ]]
-- See `:help vim.o`

vim.opt.isfname:append('@-@')

vim.o.guicursor = ''
vim.o.termguicolors = true
vim.o.lazyredraw = false
vim.o.mouse = ''
vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false
--vim.o.clipboard = 'unnamedplus'

vim.o.updatetime = 50
vim.o.timeout = true
vim.o.timeoutlen = 100

vim.o.cmdheight = 0
vim.o.scrolloff = 2
vim.wo.signcolumn = 'yes'
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 4
vim.o.colorcolumn = '100'

vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.conceallevel = 2
vim.o.foldenable = false
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

vim.o.breakindent = true
vim.o.linebreak = true
vim.o.showbreak = '↪ '
vim.o.listchars = 'tab:│→,extends:⟩,precedes:⟨,trail:·,nbsp:␣'
vim.o.list = false

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.expandtab = false
vim.o.spell = false
vim.o.completeopt = 'menuone,noselect'

vim.o.nrformats = 'bin,hex,alpha'

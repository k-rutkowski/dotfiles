set nocompatible
call pathogen#infect()

" -- Search files recursively
set path+=**
set wildmenu

" -- Create the 'tags' file
command! MakeTags !ctags -R .

" -- Display
set title
set number
set relativenumber
set ruler
set wrap
set scrolloff=3
set guioptions=T
set cursorline
set tabstop=4
set shiftwidth=4
set foldcolumn=1

set ff=unix
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
if has("win32")
	lang C
	set guifont=Consolas:h9:cANSI
	set lines=30
	set columns=130
endif

" -- Search
set ignorecase
set smartcase
set hlsearch
set incsearch

" -- Behaviour
set backspace=2
set hidden
set clipboard=unnamed

" -- Syntax
syntax enable
filetype on
filetype plugin on
filetype indent on

" -- Beep
set visualbell
set noerrorbells

" -- Mapping
let mapleader = ","

imap jk <Esc>
imap jK <Esc>
imap Jk <Esc>
imap JK <Esc>
vmap jk <Esc>
vmap JK <Esc>
vmap jK <Esc>
vmap Jk <Esc>
noremap ; :
noremap \ ;

nnoremap j gj
nnoremap k gk
nnoremap gO O<Esc>j
nnoremap go o<Esc>k

nnoremap <silent><C-h> :set hlsearch!<cr>
nnoremap <silent><C-l> :call NumberToggle()<cr>

nmap <silent><C-n> :tabnew<cr>
nmap <silent><C-j> :tabnext<cr>
nmap <silent><C-k> :tabprevious<cr>
map <silent><C-n> :tabnew<cr>
map <silent><C-j> :tabnext<cr>
map <silent><C-k> :tabprevious<cr>
imap <silent><C-n> <ESC>:tabnew<cr>
imap <silent><C-j> <ESC>:tabnext<cr>
imap <silent><C-k> <ESC>:tabprevious<cr>

no <left> <Nop>
no <up> ddkP
no <right> <Nop>
no <down> ddp
ino <left> <Nop>
ino <up> <Nop>
ino <right> <Nop>
ino <down> <Nop>
vno <left> <Nop>
vno <up> <Nop>
vno <right> <Nop>
vno <down> <Nop>

" -- Colors
set background=dark
colorscheme solarized

" -- Functions
function! EnableRelativeNumber()
	set number
	set relativenumber
endfunction

function! DisableRelativeNumber()
	set number
	set norelativenumber
endfunction

function! NumberToggle()
	if &relativenumber == 1
		call DisableRelativeNumber()
	else
		call EnableRelativeNumber()
	endif
endfunction

autocmd InsertEnter * :call DisableRelativeNumber()
autocmd InsertLeave * :call EnableRelativeNumber()

" -- Turn off line highlight in insert mode
autocmd InsertEnter * set nocul
autocmd InsertLeave * set cul

" -- Snippets
"nnoremap <leader>switch :-1read $HOME/.vim/snippets/switch.c<cr>wa


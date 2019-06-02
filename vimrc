set nocompatible
call pathogen#infect()

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
imap JK <Esc>
vmap jk <Esc>
vmap JK <Esc>
noremap ; :
noremap \ ;

nnoremap j gj
nnoremap k gk
nnoremap gO O<Esc>j
nnoremap go o<Esc>k

nmap n nzz
nmap N Nzz
nmap } }zz
nmap { {zz

nnoremap <silent><C-h> :set hlsearch!<cr>
nnoremap <silent><C-l> :call NumberToggle()<cr>

nmap <silent><C-Tab> :tabnext<cr>
nmap <silent><C-S-Tab> :tabprevious<cr>
nmap <silent><C-n> :tabnew<cr>
map <silent><C-Tab> :tabnext<cr>
map <silent><C-S-Tab> :tabprevious<cr>
map <silent><C-n> :tabnew<cr>
imap <silent><C-n> <ESC>:tabnew<cr>
imap <silent><C-S-Tab> <ESC>:tabprevious<cr>
imap <silent><C-Tab> <ESC>:tabnext<cr>

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
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul


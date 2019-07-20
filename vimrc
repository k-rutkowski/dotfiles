set nocompatible
filetype off

" -- Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'micha/vim-colors-solarized'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()

filetype plugin indent on
syntax enable

" -- Colors
set background=dark
colorscheme solarized

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
set linebreak
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

" -- Code formatting shortcuts (clang format plugin)
autocmd FileType c,cpp,objc nnoremap <buffer><leader>f :<C-u>ClangFormat<cr>
autocmd FileType c,cpp,objc vnoremap <buffer><leader>f :ClangFormat<cr>
"autocmd FileType c,cpp,objc map <buffer><leader>x <Plug>(operator-clang-format)
nmap <Leader>af :ClangFormatAutoToggle<cr>

" -- Snippets
"nnoremap <leader>switch :-1read $HOME/.vim/snippets/switch.c<cr>wa


set nocompatible
filetype off

" -- Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'micha/vim-colors-solarized'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'benmills/vimux'
Plugin 'k-rutkowski/vim-toggle-quickfix'
call vundle#end()

filetype plugin indent on
syntax enable

" -- Colors
set background=dark
colorscheme solarized
set t_Co=256

" -- Search files recursively
set path+=**

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
set wildmenu

set ff=unix
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
"if has("win32")
"	lang C
"	set guifont=Consolas:h9:cANSI
"	set lines=30
"	set columns=130
"endif

" -- Search
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

" -- Behaviour
set backspace=2
set hidden
if has("win32")
	set clipboard=unnamed
else
	set clipboard=unnamedplus
endif

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

" windows
map <leader>w <C-w>w
map <leader>q <C-w>q
map <leader>r <C-w>r
map <leader>h <C-w>s
map <leader>v <C-w>v

" buffers and args
nmap <silent><leader>n :bnext<cr>
nmap <silent><leader>p :bprevious<cr>
nmap <silent><leader>d :bdelete<cr>
nmap <silent><leader>an :next<cr>
nmap <silent><leader>ap :previous<cr>

" disable arrows
no <left> <Nop>
no <up> <Nop>
no <right> <Nop>
no <down> <Nop>
ino <left> <Nop>
ino <up> <Nop>
ino <right> <Nop>
ino <down> <Nop>
vno <left> <Nop>
vno <up> <Nop>
vno <right> <Nop>
vno <down> <Nop>

" edit vim config
nmap <leader>rc :tabfind $MYVIMRC<cr>


" -- Functions

function! MakeCppTags()
	silent! execute '!ctags --language-force=c++ --c++-kinds=+p --fields=+iaS --extra=+q -h "h.hpp.inl.h++.hh.hcc" -R .'
	redraw!
	if v:shell_error != 0
		echo 'failed to create tags (' v:shell_error ')'
	else
		echo 'tags created'
	endif
endfunction
command! MakeCppTags :call MakeCppTags()

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

" -- Make quickfix window show at the bottom instead of bottom right
autocmd FileType qf wincmd J

" -- Show absolute line numbers in insert mode
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

" -- NerdTree settings
let g:NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
nmap <silent><leader>k :NERDTreeToggle<cr>
nmap <silent><leader>s :NERDTreeFind<cr><leader>w<cr>
nmap <silent><leader>S :NERDTreeFind<cr>

" -- YouCompleteMe settings
set completeopt-=preview
let g:ycm_add_preview_to_completeopt=0
let g:ycm_collect_identifiers_from_tags_files=1

" -- Toggle Quickfix Window
nmap <leader>e <Plug>window:quickfix:loop

" -- Snippets
"nnoremap <leader>switch :-1read $HOME/.vim/snippets/switch.c<cr>wa


" .vimrc



" compatibility
set nocompatible
set encoding=utf-8

" Vundle
filetype off                                        " required


" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
 Plugin 'gmarik/Vundle.vim'

" relative and fixed numbers
Plugin 'jeffkreeftmeijer/vim-numbertoggle'

" A few themes cuz I love colors
Plugin 'tomasr/molokai'
Plugin 'whatyouhide/vim-gotham'
Plugin 'MaxSt/FlatColor'
Plugin 'morhetz/gruvbox'
Plugin 'daylerees/colour-schemes'
Plugin 'cakebaker/scss-syntax.vim'



" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Theme selection
colorscheme molokai

" Syntax highlighting

" Enable syntax highighting
syntax enable
" 256 colours, please
set t_Co=256

let mapleader = " "


" Set relevant filetypes
au BufRead,BufNewFile *.scss set filetype=scss.css
au BufRead,BufNewFile *.md set filetype=markdown


" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Tabs, indentation and lines

filetype plugin indent on
" 4 spaces please
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
" Round indent to nearest multiple of 4
set shiftround
" No line-wrapping
set nowrap



"interactions

" start scrolling slightly before the cursor reaches an edge
set scrolloff=3
set sidescrolloff=5
" scroll sideways a character at a time, rather than a screen at a time
set sidescroll=1
" allow motions and back-spacing over line-endings etc
set backspace=indent,eol,start
set whichwrap=h,l,b,<,>,~,[,]
" underscores denote words
set iskeyword-=_
set colorcolumn=85





" Visual decorations

" Show status line
set laststatus=2
" Show what mode you’re currently in
set showmode
" Show what commands you’re typing
set showcmd
" Allow modelines
set modeline
" Show current line and column position in file
set ruler
" Show file title in terminal tab
set title

" Set relative line numbers if we can...
set relativenumber
set number

" Highlight current line
set cursorline
" Don't keep results highlighted after searching...
set nohlsearch
" ..just highlight as we type
set incsearch
" ignore case when searching...
set ignorecase
" ..except if we input a capital letter
set smartcase


function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>





" Key mappings

" jj to throw you into normal mode from insert mode
 inoremap jj <esc>
 " jk to throw you into normal mode from insert mode
 inoremap jk <esc>
" Disable arrow keys (hardcore)
 map  <up>    <nop>
 imap <up>    <nop>
 map  <down>  <nop>
 imap <down>  <nop>
 map  <left>  <nop>
 imap <left>  <nop>
 map  <right> <nop>
 imap <right> <nop>

nnoremap ; :

" Examples  
" din( - "Delete in next ()" 
" vin( - "Select in next ()" 
" cin( - "Change in next () (great for function calls)
 vnoremap <silent> in( :<C-U>normal! f(vi(<cr> 
 onoremap <silent> in( :<C-U>normal! f(vi(<cr>

" working with split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

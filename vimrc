execute pathogen#infect()
set nocompatible
syntax on
filetype plugin indent on

filetype plugin indent on
syntax on
syntax enable

"" Colors
colorscheme solarized
set term=xterm-256color
let g:solarized_termtrans = 1
set background=dark

"" Window
set number
set scrolloff=3
set lazyredraw
set noerrorbells
set novisualbell
set splitright
set splitbelow
set cursorline
set colorcolumn=80
set hidden

"" Text
set nowrap
set linebreak
set tabstop=2 shiftwidth=2
set expandtab
set backspace=indent,eol,start
set list
set listchars=trail:.
set showmatch
set autoindent
set smartindent

"" Stuff
set nobackup
set nowb
set noswapfile
set foldmethod=manual
set encoding=utf-8
set history=1000
set autoread
set clipboard=unnamed
set iskeyword+=_,$,@,%,#,-

"" Mouse
set mouse=a
set mousehide
set ttymouse=xterm2

"" Search
set hlsearch
set incsearch
set ignorecase

"" Command mode
set wildmenu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.bundle,coverage,.DS_Store,_html,.git,*.rbc,*.class,.svn,vendor/gems/*,vendor/rails/*
set cmdheight=2
set laststatus=2
set nofoldenable

"" Fix EX command movements
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

"" Vim Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Comma for leader
let mapleader = ","
let maplocalleader = ","
let g:mapleader = ","

nmap <leader><space> :CtrlP<CR>
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ctrlp_user_command = 'ag %s -l --nogroup --nocolor --column -g ""'
let g:ctrlp_use_caching = 0

"map <C-f> :Ack<space>""<C-b>
map <leader>f :Ack<space>""<C-b>

map <leader>1 <Esc>:w<Enter>:bp<Enter>
map <leader>2 <Esc>:w<Enter>:bn<Enter>
map <leader>3 :b<space>
map <leader>4 <Esc>:w<Enter>:bd<Enter>

command FixTrailingSpaces %s/\s\+$//

source ~/.vim/scripts/testing.vim

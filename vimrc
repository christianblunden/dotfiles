execute pathogen#infect()
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

source ~/.vim/scripts/testing.vim

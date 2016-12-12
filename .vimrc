set mouse=a
set nocompatible

set incsearch
set ignorecase

set backspace=indent,eol,start
set autoindent
set smartindent

set number
set relativenumber
set ruler
set showcmd

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin indent on
autocmd FileType text setlocal textwidth=78


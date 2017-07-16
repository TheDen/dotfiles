set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'pangloss/vim-javascript'
Plugin 'ervandew/supertab'
Plugin 'rdolgushin/groovy.vim'
call vundle#end()            " required
filetype plugin indent on    " required
:syntax on
:set autoindent
:set hlsearch
":set number 
:set cursorline
:set wildmenu
:set showmatch
:set incsearch
:set hlsearch
:nnoremap <leader>u :GundoToggle<CR>

:set expandtab
:set shiftwidth=2
:set softtabstop=2 

filetype plugin indent on
:set tabstop=2
:set shiftwidth=2

set backspace=indent,eol,start


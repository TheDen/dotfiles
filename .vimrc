set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'pangloss/vim-javascript'
Plugin 'ervandew/supertab'
Plugin 'rdolgushin/groovy.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'matze/vim-move'
Plugin 'ambv/black'
call vundle#end()            " required

filetype plugin indent on    " required
syntax on
set ttyfast
set autoindent
set hlsearch
"map 'C' set number
nmap <C-N><C-N> :set invnumber<CR>
set cursorline
set wildmenu
set showmatch
set incsearch
set hlsearch
nnoremap <leader>u :GundoToggle<CR>

set history=1000
set undofile
set undodir=~/vim_backup
set undoreload=10000

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
autocmd FileType python set tabstop=2|set shiftwidth=2|set expandtab

set backspace=indent,eol,start

au BufReadPost Jenkinsfile set syntax=groovy
au BufReadPost Jenkinsfile set filetype=groovy

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

let g:move_key_modifier = 'C'

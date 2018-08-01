"" Vundle Start
set nocompatible
filetype off
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
Plugin 'ekalinin/Dockerfile.vim'
call vundle#end()
""" End Vundle

filetype plugin indent on " Filetype auto-detection
syntax on " Syntax highlighting
set ttyfast " Fast terminal conn for faster redraw
set autoindent " Turn on autoident
set hlsearch " Highlight searches

"" <ctrl+n><ctrl+n> toggles line numbers
nmap <C-N><C-N> :set invnumber<CR>

set cursorline " Horizontal cursorline
set ruler " Always show current position
set autoread " Read when file is modified externally

set laststatus=2 " Always show the status line

""" Toggle paste/nopaste
nnoremap <C-y> :set invpaste paste?<CR>
set pastetoggle=<C-y>
set showmode

"" No noise
set noerrorbells
set novisualbell

""" Enable 256 colors
if &term == 'xterm' || &term == 'screen-256color'
  set t_Co=256
endif
if &term =~ 'xterm'
  set t_ut=
endif

""" Autocomplete in menu
set wildmenu
set wildmode=longest:list,full

set showmatch " Show matching braces
set incsearch " Show matches while typing

"" Persistent edit history
set history=1000
set undofile
set undodir=~/vim_backup
set undoreload=10000

set tabstop=2
set shiftwidth=2
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs
autocmd FileType python set tabstop=2|set shiftwidth=2|set expandtab

set backspace=indent,eol,start

au BufReadPost Jenkinsfile set syntax=groovy
au BufReadPost Jenkinsfile set filetype=groovy

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

let g:move_key_modifier = 'C' " ctrl+k moves linee up, ctrl+j moves line down

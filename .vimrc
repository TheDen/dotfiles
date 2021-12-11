"" Vundle Start
set nocompatible
filetype on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ervandew/supertab'
Plugin 'rdolgushin/groovy.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'matze/vim-move'
Plugin 'psf/black'
Plugin 'z0mbix/vim-shfmt'
Plugin 'fatih/vim-go'
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
set history=10000
set undofile
set undodir=~/vim_backup
set undoreload=100000

set tabstop=2
set shiftwidth=2
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs
autocmd FileType python set tabstop=2|set shiftwidth=2|set expandtab

set backspace=indent,eol,start

au BufReadPost Jenkinsfile set syntax=groovy
au BufReadPost Jenkinsfile set filetype=groovy

autocmd BufNewFile,BufRead Dockerfile* setfiletype Dockerfile

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

let g:move_key_modifier = 'C' " ctrl+k moves line up, ctrl+j moves line down

" autocmd bufwritepost *.js silent !semistandard % --fix
" set autoread

set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim

"" map :Black
nmap ,= :Black<CR>
vmap ,= :Black<CR>

let g:go_highlight_space_tab_error = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" shfmt configuration
let g:shfmt_extra_args = '-i 2 -ci -sr'
let g:shfmt_fmt_on_save = 1

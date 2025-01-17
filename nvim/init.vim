set nocompatible
filetype on
call plug#begin()
Plug 'ervandew/supertab'
Plug 'rdolgushin/groovy.vim'
Plug 'sheerun/vim-polyglot'
Plug 'matze/vim-move'
Plug 'psf/black'
Plug 'z0mbix/vim-shfmt'
Plug 'fatih/vim-go'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-scripts/dante.vim'
Plug 'gko/vim-coloresque'
Plug 'vitalk/vim-shebang'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'cuducos/yaml.nvim'
Plug 'ibhagwan/fzf-lua'
call plug#end()

colorscheme dante
set background=dark
set termguicolors&

syntax on " Syntax highlighting
filetype plugin indent on " Filetype auto-detection
set ttyfast " Fast terminal conn for faster redraw
set autoindent " Turn on autoident
set hlsearch " Highlight searches

"" <ctrl+n><ctrl+n> toggles line numbers
nmap <C-N><C-N> :set invnumber<CR>

set cursorline " Horizontal cursorline
set ruler " Always show current position
set autoread " Read when file is modified externally

set laststatus=2 " Always show the status line

"" Show full path of current file
set statusline+=%F


""" Toggle paste/nopaste
nnoremap <C-y> :set invpaste paste?<CR>
set pastetoggle=<C-y>
set showmode

""" Toggle syntax
:map <C-b> :if exists("g:syntax_on") <Bar>
      \   syntax off <Bar>
      \ else <Bar>
      \   syntax enable <Bar>
      \ endif <CR>

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
set undodir=~/nvim_backup
set undoreload=1000000

set tabstop=2
set shiftwidth=2
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs
autocmd FileType python set tabstop=2|set shiftwidth=2|set expandtab

set backspace=indent,eol,start

au BufReadPost Jenkinsfile set syntax=groovy
au BufReadPost Jenkinsfile set filetype=groovy

autocmd BufNewFile,BufRead Dockerfile* setfiletype Dockerfile

"AddShebangPattern! zsh ^#!.*/bin/bash
"au BufReadPost *.sh set syntax=zsh

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
map ,= :Black<CR>

let g:go_highlight_space_tab_error = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'


" shfmt configuration
let g:shfmt_extra_args = '-i 2 -ci -sr'
let g:shfmt_fmt_on_save = 1

" Toggle spellcheck
set spelllang=en_au
nnoremap <C-s> :set spell!<CR>

" CTRL-X to cut
vnoremap <C-X> "+x

" CTRL-C to copy
vnoremap <C-C> "+y

" disable mouse
set mouse=

" Toggle vertical cursorline
map <C-Bslash> :set cursorcolumn!<Bar>set cursorline!<CR>

" Golines
let g:go_fmt_command = "golines"
let g:go_fmt_options = {
    \ 'golines': '-m 100',
    \ }

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

hi clear CursorLine
hi CursorLine gui=underline cterm=underline

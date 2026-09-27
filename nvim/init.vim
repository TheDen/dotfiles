call plug#begin()
Plug 'vim-scripts/VimCompletesMe'
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
"" nvim-treesitter removed: it was never configured (no .setup{} call), so it
"" only ever acted as a parser installer -- vim-polyglot does the highlighting.
"" yaml.nvim still needs a yaml parser, and it used the one that shipped inside
"" the plugin dir, so that parser now lives at ~/.config/nvim/parser/yaml.so.
"" It is an arch-specific binary, hence not committed to this repo; on a new
"" machine rebuild it with tree-sitter-cli or reinstate nvim-treesitter briefly.
Plug 'cuducos/yaml.nvim'
Plug 'ibhagwan/fzf-lua'
Plug 'Glench/Vim-Jinja2-Syntax'
call plug#end()

colorscheme dante
set background=dark
set termguicolors " True colour (was `termguicolors&`, which reset it back off)

syntax on " Syntax highlighting
filetype plugin indent on " Filetype auto-detection
set autoindent " Turn on autoident
set hlsearch " Highlight searches
set ignorecase " Case-insensitive search...
set smartcase " ...unless the pattern has a capital (matches telescope's --smart-case)

"" <ctrl+n><ctrl+n> toggles line numbers
nmap <C-N><C-N> :set invnumber<CR>

set cursorline " Horizontal cursorline
set ruler " Always show current position
set autoread " Read when file is modified externally

set laststatus=2 " Always show the status line

"" Show full path of current file. nvim's default 'statusline' is empty, so a
"" bare `+=%F` threw away the position info 'ruler' would otherwise give.
set statusline=%F%m%r%h%w%=%l:%c\ %P


""" Toggle paste/nopaste
"" ('pastetoggle' was removed in nvim 0.11 -- E519. Terminal paste is
"" bracketed and handled automatically, so this is only a manual escape hatch.)
nnoremap <C-y> :set invpaste paste?<CR>
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

set backspace=indent,eol,start

"" Filetype overrides. These deliberately *override* nvim's own detection
"" (which types Jenkinsfile as `Jenkinsfile` and .html as `html`), so they use
"" `set filetype=` rather than `setfiletype`, which is a no-op once a filetype
"" has already been set. Setting 'filetype' pulls in syntax + indent, so there
"" is no need to set 'syntax' as well.
"" Dockerfile* is dropped: nvim detects it natively as lowercase `dockerfile`,
"" and the old capitalised spelling only resolved by luck on case-insensitive
"" macOS -- it would have broken on Linux.
au BufNewFile,BufRead Jenkinsfile* set filetype=groovy
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.j2 set filetype=jinja

"AddShebangPattern! zsh ^#!.*/bin/bash
"au BufReadPost *.sh set syntax=zsh

"" Trailing whitespace is highlighted by vim-better-whitespace (on by default),
"" so the hand-rolled `match ExtraWhitespace` block that used to live here is
"" gone -- its BufWinLeave `clearmatches()` also wiped other plugins' matches.
let g:better_whitespace_guicolor = 'red'

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
" NOTE: <C-s> is XOFF under terminal flow control and will appear to freeze the
" terminal unless you run `stty -ixon`. <leader>z is the safe alternative --
" it sits near vim's own z= / zg spell commands, and avoids <leader>s*, which
" is vim-better-whitespace's StripWhitespace operator.
set spelllang=en_au
nnoremap <C-s> :set spell!<CR>
nnoremap <leader>z :set spell!<CR>

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

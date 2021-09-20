" put vim-plugin first 
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" color schemes
Plug 'arzg/vim-colors-xcode'

" code completion
Plug 'neoclide/coc.nvim'
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user'
  \| Plug 'glts/vim-textobj-comment'
Plug 'janko/vim-test'
Plug 'vim-scripts/vcscommand.vim'
Plug 'mhinz/vim-signify'
" Markdown
Plug 'gabrielelana/vim-markdown'
Plug 'junegunn/goyo.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'kamykn/spelunker.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

" termsize
set splitbelow
set termwinsize=30x0

" line number
set number

" highlight cursor line
set cursorline
" add empty line
nnoremap <F4> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <F5> :set paste<CR>m`O<Esc>``:set nopaste<CR>
set shiftwidth=4
set tabstop=4
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use , as LEADER
let mapleader=","

" Choose colorscheme
colorscheme xcodedarkhc

" Source Vim configuration file and install plugins
nnoremap <silent><leader>1 :source ~/.vimrc \| :PlugInstall<CR>

" switch between panes
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" navigate tabs easily
nnoremap H gT
nnoremap L gt

" yank/paste to clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" show terminal
noremap <Leader>t :term<cr>
" close terminal
:tnoremap <Esc> <C-W>c

" MarkdownPreview
noremap <Leader>m :MarkdownPreview<cr>
" Goyo
noremap <Leader>g :Goyo 85%x100%<cr>
" fzf map
nnoremap <silent> <C-f> :Files<CR>
" rg map
nnoremap <silent> <Leader>f :Rg<CR>

source ./vim/nerdtree.vim
source ./vim/spelunker.vim
source ./vim/coc.vim
source ./vim/ctrlp.vim

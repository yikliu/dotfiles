" put vim-plugin first 
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'ctrlpvim/ctrlp.vim'

" code completion
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user'
\| Plug 'glts/vim-textobj-comment'
Plug 'vim-scripts/vcscommand.vim'
Plug 'mhinz/vim-signify'
Plug 'gabrielelana/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'kamykn/spelunker.vim'
Plug 'easymotion/vim-easymotion'

" color schemes
Plug 'arzg/vim-colors-xcode'
Plug 'NLKNguyen/papercolor-theme'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'junegunn/seoul256.vim'
Plug 'Rigellute/rigel'

"airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Pencil
Plug 'preservim/vim-pencil'

" coc-jedi
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }

"jedi-vim
Plug 'davidhalter/jedi-vim'

"javscript and jsx syntax
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Initialize plugin system
call plug#end()

" Choose colorscheme
set t_Co=256   " This is may or may not needed.
set background=dark
colorscheme papercolor 
" colorscheme catppuccin_latte 
" colo seoul256
set termguicolors

" syntax enable
" colorscheme rigel

" termsize
set splitbelow
set termwinsize=30x0

" line number
" set number
" turn hybrid line numbers on
set number relativenumber
set nu rnu

" tabsize
set tabstop=4
set shiftwidth=4
set expandtab

" Enable cursor line position tracking:
set cursorline
" Remove the underline from enabling cursorline:
highlight clear CursorLine
" Set line numbering to red background:
highlight CursorLineNR ctermbg=red

" add empty line
nnoremap zj o<Esc>k
nnoremap zk O<Esc>j

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

set mouse=a               " tell vim to recognize mouse commands in "all" modes
if !has('nvim')
    set ttymouse=xterm2       " tell vim you're using xterm, this isn't necessary but I believe improves performance
endif
set ttyfast               " improve fluidity of mouse commands, this isn't necessary but I believe improves performance

set autoindent
set smartindent

" set paste                 " don't mess up the indenting of pasted text
vmap <C-C> "+y            " map ctrl-c to copy a block of text selected by the mouse

" Use , as LEADER
let mapleader=","

" Source Vim configuration file and install plugins
nnoremap <silent><leader>1 :source ~/.vimrc \| :PlugInstall<CR>

" switch between panes
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" navigate tabs easily
nnoremap H :bp<CR>
nnoremap L :bn<CR>

" navigate buffers
nnoremap <silent> <Leader>h gT
nnoremap <silent> <Leader>l gt

" yank/paste to clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" show terminal
noremap <Leader>t :term<cr>
" close terminal
tnoremap <Leader>c : <C-W>:q!<cr>
tnoremap <Esc> <C-W>N
tnoremap <Esc><Esc> <C-W>N

set timeout timeoutlen=1000  " Default
set ttimeout ttimeoutlen=100  " Set by defaults.vim

" MarkdownPreview
noremap <Leader>m :MarkdownPreview<cr>

" Goyo
noremap <Leader>g :Goyo 80%x100%<cr>

" Trigger Limelight with Goyo
" autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!

" Limelight
nmap <Leader>l <Plug>(Limelight)
xmap <Leader>l <Plug>(Limelight)

" fzf map
nnoremap <silent> <C-f> :Files<CR>
" rg map
nnoremap <silent> <Leader>f :Rg<CR>

" close buffer
nnoremap <Leader>x :bp\|bd #<CR>

"airline
let g:airline#extensions#tabline#enabled = 1
let g:rigel_airline = 1
let g:airline_theme = 'rigel'

" vim-javascript
let g:javascript_plugin_flow = 1

source ~/dotfiles/vim/nerdtree.vim
source ~/dotfiles/vim/spelunker.vim
source ~/dotfiles/vim/coc.vim
source ~/dotfiles/vim/ctrlp.vim
source ~/dotfiles/vim/pencil.vim
source ~/dotfiles/vim/limelight.vim

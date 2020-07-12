" put vim-plugin first 
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf'
" color schemes
Plug 'arzg/vim-colors-xcode'

" Initialize plugin system
call plug#end()

" Choose colorscheme
colorscheme xcodedark


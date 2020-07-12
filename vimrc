if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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


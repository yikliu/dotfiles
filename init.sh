!/bin/zsh

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -f ~/.vimrc
ln -s ${dir}/vim/vimrc ~/.vimrc

rm -f ~/.tmux.conf
ln -s ${dir}/tmux ~/.tmux.conf

rm -f ~/.zshrc
ln -s ${dir}/zsh/zshrc ~/.zshrc

rm -f ~/.sf.js
ln -s ${dir}/sf.js ~/.sf.js

rm -rf ~/.config/nvim
ln -s ${dir}/nvim ~/.config/nvim

source ~/.zshrc



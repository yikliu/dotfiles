#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rm -f ~/dotfiles
ln -s ${dir} ~/dotfiles
rm -f ~/.bashrc
ln -s ${dir}/rc ~/.bashrc
rm -f ~/.bash_profile
ln -s ${dir}/profile ~/.bash_profile
rm -f ~/.vimrc
ln -s ${dir}/vimrc ~/.vimrc
rm -f ~/.tmux.conf
ln -s ${dir}/tmux ~/.tmux.conf
rm -f ~/.tridactylrc
ln -s ${dir}/tridactylrc ~/.tridactylrc
rm -f ~/.zshrc
ln -s ${dir}/zshrc ~/.zshrc

if [ -n "$ZSH_VERSION" ]; then
	source ~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
	source ~/.bashrc

source ${dir}/myalias
source ~/amazon

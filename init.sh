#!/bin/bash

dir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

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
rm -f ~/.ctags
ln -s ${dir}/ctags ~/.ctags
rm -f ~/.tridactylrc
ln -s ${dir}/tridactylrc ~/.tridactylrc

source ~/.bashrc
source ${dir}/myalias
source ~/amazon
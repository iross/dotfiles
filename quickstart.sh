#! /bin/bash
ln -s ../.tmux.conf tmuxconf
ln -s ../.vimrc vimrc
cd ..
git clone https://github.com/iross/.vim .vim
cd .vim
git submodule init && git submodule update


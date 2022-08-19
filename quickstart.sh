#! /bin/bash
cat tmuxconf >> ../.tmux.conf
cat vimrc >> ../.vimrc
cat gitconfig >> ../.gitconfig
cat bashrc >> ../.bashrc
cat bash_aliases >> ../.bash_aliases
cd ..
git clone https://github.com/iross/.vim .vim
cd .vim
git submodule init && git submodule update


#!/bin/sh

git clone https://github.com/GreenRiverRUS/dotfiles.git ~/dotfiles
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ln -s ~/dotfiles/vimrc ~/.vimrc
mkdir -p ~/.vim/colors/
ln -s ~/dotfiles/vim_darcula_theme/colors/darcula.vim ~/.vim/colors/

vim +PluginInstall +qall

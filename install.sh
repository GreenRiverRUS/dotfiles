#!/bin/bash

prompt() {
    while true; do
        read -p "$1 [Y/n] " -n 1 -r
        if [ -n "$REPLY" ]; then echo ""; fi
        case "$REPLY" in
            y|Y|"" ) return 0;;
            n|N ) return 1;;
            * ) ;;
        esac
    done
}

sudo apt-get install git
git clone --recurse-submodules https://github.com/GreenRiverRUS/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/gitconfig ~/.gitconfig

if prompt "Setup vim?"; then
    git clone https://github.com/gmarik/vundle.vim.git ~/.vim/bundle/Vundle.vim
    ln -s ~/dotfiles/vimrc ~/.vimrc
    mkdir -p ~/.vim/colors/
    ln -s ~/dotfiles/vim_darcula_theme/colors/darcula.vim ~/.vim/colors/
    vim +PluginInstall +qall
fi

if prompt "Setup zsh?"; then
    sudo apt-get install zsh zsh-syntax-highlighting
    ln -s ~/dotfiles/zshrc ~/.zshrc
    if prompt "Set zsh as default shell?"; then
        sudo chsh -s $(which zsh) "$USER"
    fi
fi

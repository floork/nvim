#!/bin/bash

# install the dependencies
if [ -x "$(command -v pacman)" ]
then
	sudo pacman -Syu
	sudo pacman -S --noconfirm --needed ctags nodejs npm neovim
elif [ -x "$(command -v dnf)" ]
then
    sudo -S dnf -y install ctags nodejs npm neovim
elif [ -x "$(command -v apt-get)" ]
then
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get -y --yes install exuberant-ctags nodejs npm neovim
else
    echo 'This Distro is not supported!'
fi

# copy the configs to config location
if [ -d "~/.config/nvim" ]; then
    curl -s https://raw.githubusercontent.com/floork/nvim/main/init.vim > ~/.config/nvim/init.vim
else
    mkdir ~/.config/nvim
    curl -s https://raw.githubusercontent.com/floork/nvim/main/init.vim > ~/.config/nvim/init.vim
fi

sleep 2

nvim -es +PlugInstall

cd ~/.config/nvim/plugged/coc.nvim/

yarn install
yarn build

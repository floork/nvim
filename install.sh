#!/bin/bash

CHOICE=$(whiptail --menu "Choose an option" 18 100 10 \
    "1)" "Install Lunarvim and dependencies" \
    "2)" "Reinstall Lunarvim" \
    "0)" "Exit this script" \ 3>&1 1>&2 2>&3)
    case $CHOICE in
    "1)")
        inst
    ;;
    "2)")
        reinst
    ;;
    "3)")
        exit
    ;;
    esac
}

inst(){
    # install neovim
    bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install-neovim-from-release)

    # install lunarvim
    LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh)
}

reinst(){
    # Unstow dotfiles
    echo 'Unstowing dotfiles...'
    cd ~/.dotfiles && stow --delete lvim

    # Uninstall
    echo 'Running uninstall script...'
    bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/uninstall.sh)

    # Install neovim
    echo 'Installing neovim...'
    bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install-neovim-from-release)

    # Install lunarvim
    echo 'Installing lunarvim...'
    LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh)

    # Stow dotfiles
    echo 'Stowing dotfiles...'
    rm -rf ~/.config/lvim
    cd ~/.dotfiles && stow lvim
}

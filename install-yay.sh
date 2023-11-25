#!/bin/bash

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin
cd yay-bin
makepkg -si
cd .. && rm -rf yay-bin

yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

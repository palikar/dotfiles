#!/bin/bash

sudo apt-get install git
mkdir -p ~/code  && git clone https://github.com/palikar/dotfiles ~/code/dotfiles
cd ~/code/dotfiles && . ./setuper/install.sh

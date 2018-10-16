#!/bin/bash

sudo apt-get install git
mkdir -p ~/code  && git clone xhttps://github.com/palikar/dotfiles ~/code/dotfiles
cd ~/code/dotfiles && . install.sh

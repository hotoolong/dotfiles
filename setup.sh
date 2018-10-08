#!/bin/bash

FILES=`ls -1a | grep -E '^\.' | grep -v -E '^(.|..|.git)$'`

for file in ${FILES[@]}
do
  ln -s $HOME/dotfiles/$file $HOME/$file
done

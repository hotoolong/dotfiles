#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
FILES=`ls -1a | grep -E '^\.' | grep -v -E '^(.|..|.git)$'`


for file in ${FILES[@]}
do
  ln -svib $SCRIPT_DIR/$file $HOME/$file
done
